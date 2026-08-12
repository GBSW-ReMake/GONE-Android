import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/auth_flow_notifier.dart';
import 'login_page.dart';
import 'role_selection_page.dart';
import 'signup_page.dart';
import 'splash_page.dart';

class AuthFlowPage extends ConsumerWidget {
  const AuthFlowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flow = ref.watch(authFlowProvider);
    final controller = ref.read(authFlowProvider.notifier);

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 320),
      child: switch (flow.destination) {
        AuthDestination.splash => SplashPage(
          key: const ValueKey('splash'),
          onFinished: controller.finishSplash,
        ),
        AuthDestination.roleSelection => RoleSelectionPage(
          key: const ValueKey('roleSelection'),
          onSelected: controller.selectRole,
        ),
        AuthDestination.login => LoginPage(
          key: const ValueKey('login'),
          role: flow.role,
          onBack: controller.showRoleSelection,
          onSignup: controller.showSignup,
        ),
        AuthDestination.signup => SignupPage(
          key: const ValueKey('signup'),
          role: flow.role,
          onBack: controller.showLogin,
        ),
      },
    );
  }
}
