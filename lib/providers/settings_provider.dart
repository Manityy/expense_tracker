import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/settings_service.dart';

final settingsServiceProvider = Provider((ref) => SettingsService());

class AppSettings {
  final ThemeMode themeMode;
  final Locale locale;

  const AppSettings({
    required this.themeMode,
    required this.locale,
  });

  AppSettings copyWith({ThemeMode? themeMode, Locale? locale}) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final service = ref.read(settingsServiceProvider);
    return AppSettings(
      themeMode: await service.loadThemeMode(),
      locale: await service.loadLocale(),
    );
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await ref.read(settingsServiceProvider).saveThemeMode(mode);
    final current = state.requireValue;
    state = AsyncData(current.copyWith(themeMode: mode));
  }

  Future<void> setLocale(Locale locale) async {
    await ref.read(settingsServiceProvider).saveLocale(locale);
    final current = state.requireValue;
    state = AsyncData(current.copyWith(locale: locale));
  }
}

final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);
