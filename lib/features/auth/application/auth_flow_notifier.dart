import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/account_role.dart';

enum AuthDestination { splash, roleSelection, login, signup }

class AuthFlowState {
  const AuthFlowState({
    required this.destination,
    this.role = AccountRole.student,
  });

  final AuthDestination destination;
  final AccountRole role;

  AuthFlowState copyWith({AuthDestination? destination, AccountRole? role}) {
    return AuthFlowState(
      destination: destination ?? this.destination,
      role: role ?? this.role,
    );
  }
}

class AuthFlowNotifier extends Notifier<AuthFlowState> {
  @override
  AuthFlowState build() =>
      const AuthFlowState(destination: AuthDestination.splash);

  void finishSplash() =>
      state = state.copyWith(destination: AuthDestination.roleSelection);

  void selectRole(AccountRole role) {
    state = state.copyWith(destination: AuthDestination.login, role: role);
  }

  void showSignup() =>
      state = state.copyWith(destination: AuthDestination.signup);

  void showLogin() =>
      state = state.copyWith(destination: AuthDestination.login);

  void showRoleSelection() {
    state = state.copyWith(destination: AuthDestination.roleSelection);
  }
}

final authFlowProvider = NotifierProvider<AuthFlowNotifier, AuthFlowState>(
  AuthFlowNotifier.new,
);
