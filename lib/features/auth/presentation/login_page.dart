import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gone/features/auth/application/auth_repository_provider.dart';

import '../../../core/design_system/gone_theme.dart';
import '../domain/account_role.dart';
import 'auth_widgets.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({
    super.key,
    required this.role,
    required this.onBack,
    required this.onSignup,
    required this.onLogin,
  });

  final AccountRole role;
  final VoidCallback onBack;
  final VoidCallback onSignup;
  final VoidCallback onLogin;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _identifierError;
  String? _passwordError;

  bool get buttonEnabled =>
      _passwordController.text.isNotEmpty &&
      _identifierController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_identifierError != null || _passwordError != null) return;

    final result = await ref
        .read(authRepositoryProvider)
        .login(_identifierController.text, _passwordController.text);

    if (result != null) {
      Fluttertoast.showToast(
        msg: result.message,
        toastLength: Toast.LENGTH_SHORT,
      );
      return;
    }

    widget.onLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: GonePrimaryButton(
            label: '로그인',
            enabled: buttonEnabled,
            onPressed: _submit,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GoneLogo(width: 80),
              const SizedBox(height: 24),
              Text(
                '학교생활을 더 간편하게',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                  color: GoneColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'GONE에 로그인하고 학교의 서비스를\n한곳에서 이용해보세요.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: GoneColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
              TextField(
                controller: _identifierController,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: const [AutofillHints.username],
                onChanged: (_) => setState(() => _identifierError = null),
                decoration: InputDecoration(
                  labelText: '아이디',
                  hintText: '아이디 또는 전화번호를 입력해주세요',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: const TextStyle(
                    color: GoneColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: const TextStyle(color: GoneColors.gray500),
                  errorText: _identifierError,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                enableSuggestions: false,
                autocorrect: false,
                autofillHints: const [AutofillHints.password],
                onChanged: (_) => setState(() => _passwordError = null),
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력해주세요',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelStyle: const TextStyle(
                    color: GoneColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: const TextStyle(color: GoneColors.gray500),
                  errorText: _passwordError,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '아직 회원이 아니신가요? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: GoneColors.textSecondary,
                      ),
                    ),
                    Semantics(
                      button: true,
                      label: '회원가입',
                      child: TextButton(
                        onPressed: widget.onSignup,
                        style: TextButton.styleFrom(
                          foregroundColor: GoneColors.primary,
                          minimumSize: const Size(48, 48),
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        child: const Text('회원가입'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
