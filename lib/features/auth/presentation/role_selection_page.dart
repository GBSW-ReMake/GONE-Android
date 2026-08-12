import 'package:flutter/material.dart';

import '../domain/account_role.dart';
import 'auth_widgets.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key, required this.onSelected});

  final ValueChanged<AccountRole> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GoneLogo(width: 88),
              const SizedBox(height: 28),
              Text(
                '어떤 계정으로\n로그인할까요?',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '선택한 유형에 맞는 학교 생활 서비스를 이용할 수 있어요.',
                style: textTheme.bodyMedium?.copyWith(height: 1.55),
              ),
              const Spacer(),
              Center(
                child: Image.asset(
                  'assets/images/role-selection-illustration.png',
                  width: 280,
                  semanticLabel: 'GONE 서비스 이용 안내',
                ),
              ),
              const Spacer(),
              GonePrimaryButton(
                label: '학생으로 로그인',
                onPressed: () => onSelected(AccountRole.student),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => onSelected(AccountRole.teacher),
                  child: const Text('선생님으로 로그인'),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
