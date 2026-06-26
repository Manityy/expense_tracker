import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/l10n/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../../utils/app_colors.dart';

class AppSettingsSection extends ConsumerWidget {
  const AppSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider).requireValue;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            l10n.appearance.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.sidiBlue.withValues(alpha: isDark ? 0.15 : 0.06),
            ),
          ),
          child: Column(
            children: [
              SwitchListTile(
                secondary: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode_outlined,
                  color: AppColors.sidiBlue,
                ),
                title: Text(l10n.darkMode),
                value: settings.themeMode == ThemeMode.dark,
                onChanged: (enabled) {
                  ref.read(settingsProvider.notifier).setThemeMode(
                        enabled ? ThemeMode.dark : ThemeMode.light,
                      );
                },
              ),
              Divider(height: 1, color: Theme.of(context).dividerColor),
              ListTile(
                leading: const Icon(Icons.language, color: AppColors.sidiBlue),
                title: Text(l10n.language),
                subtitle: Text(_languageLabel(l10n, settings.locale.languageCode)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _showLanguagePicker(context, ref, l10n),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _languageLabel(AppLocalizations l10n, String code) {
    return switch (code) {
      'fr' => l10n.languageFrench,
      'ar' => l10n.languageArabic,
      _ => l10n.languageEnglish,
    };
  }

  Future<void> _showLanguagePicker(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final current = ref.read(settingsProvider).requireValue.locale.languageCode;

    await showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  l10n.language,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _LanguageTile(
                label: l10n.languageEnglish,
                code: 'en',
                selected: current == 'en',
                onTap: () => _selectLocale(context, ref, const Locale('en')),
              ),
              _LanguageTile(
                label: l10n.languageFrench,
                code: 'fr',
                selected: current == 'fr',
                onTap: () => _selectLocale(context, ref, const Locale('fr')),
              ),
              _LanguageTile(
                label: l10n.languageArabic,
                code: 'ar',
                selected: current == 'ar',
                onTap: () => _selectLocale(context, ref, const Locale('ar')),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectLocale(
    BuildContext context,
    WidgetRef ref,
    Locale locale,
  ) async {
    await ref.read(settingsProvider.notifier).setLocale(locale);
    if (context.mounted) Navigator.pop(context);
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final String code;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.code,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      trailing: selected
          ? const Icon(Icons.check_circle, color: AppColors.sidiBlue)
          : null,
      onTap: onTap,
    );
  }
}
