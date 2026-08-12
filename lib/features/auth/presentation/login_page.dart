import 'package:flutter/material.dart';

import '../../../core/design_system/gone_theme.dart';
import '../domain/account_role.dart';
import 'auth_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
    required this.role,
    required this.onBack,
    required this.onSignup,
  });

  final AccountRole role;
  final VoidCallback onBack;
  final VoidCallback onSignup;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _identifierError;
  String? _passwordError;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final identifier = _identifierController.text.trim();
    setState(() {
      _identifierError = identifier.isEmpty ? '아이디 또는 전화번호를 입력해주세요.' : null;
      _passwordError = _passwordController.text.isEmpty
          ? '비밀번호를 입력해주세요.'
          : null;
    });
    if (_identifierError == null && _passwordError == null) {
      showServiceNotice(context, '로그인 서비스 연결 정보를 확인 중입니다. 잠시 후 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 14),
        child: GonePrimaryButton(label: '로그인', onPressed: _submit),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 96),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GoneBackButton(onPressed: widget.onBack, label: '로그인 유형 다시 선택'),
              const SizedBox(height: 24),
              const GoneLogo(width: 80),
              const SizedBox(height: 24),
              Text(
                '학교생활을 더 간편하게',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${widget.role.label} 계정으로 로그인하고 학교의 서비스를 한곳에서 이용해보세요.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _identifierController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
                onChanged: (_) => setState(() => _identifierError = null),
                decoration: InputDecoration(
                  labelText: '아이디',
                  hintText: '아이디 또는 전화번호를 입력해주세요',
                  errorText: _identifierError,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _passwordController,
                obscureText: true,
                autofillHints: const [AutofillHints.password],
                onChanged: (_) => setState(() => _passwordError = null),
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  hintText: '비밀번호를 입력해주세요',
                  errorText: _passwordError,
                ),
              ),
              const SizedBox(height: 28),
              Center(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '아직 회원이 아니신가요? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
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
                          textStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
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
