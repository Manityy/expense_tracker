import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/data_providers.dart';
import '../navigation/main_navigation_page.dart';
import '../onboarding/onboarding_page.dart';
import 'login_page.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user == null) return const LoginPage();
        return _AuthenticatedGate(uid: user.uid);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text(error.toString())),
      ),
    );
  }
}

class _AuthenticatedGate extends ConsumerStatefulWidget {
  final String uid;

  const _AuthenticatedGate({required this.uid});

  @override
  ConsumerState<_AuthenticatedGate> createState() => _AuthenticatedGateState();
}

class _AuthenticatedGateState extends ConsumerState<_AuthenticatedGate> {
  @override
  void initState() {
    super.initState();
    ref.read(firestoreServiceProvider).ensureOnboardingFlag(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userModelStreamProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('$e'))),
      data: (user) {
        if (user == null) return const MainNavigationPage();

        final needsOnboarding =
            !user.onboardingCompleted && user.salary <= 0;
        if (needsOnboarding) {
          return OnboardingPage(userName: user.name);
        }
        return const MainNavigationPage();
      },
    );
  }
}
