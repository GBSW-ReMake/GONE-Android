import 'package:flutter/material.dart';
import 'package:gone/core/design_system/gone_theme.dart';

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
              const GoneLogo(width: 80),
              const SizedBox(height: 24),
              Text(
                '편리한 학교생활의 시작',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                  color: GoneColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '학생 또는 선생님으로 로그인하고\n필요한 학교 서비스를 간편하게 이용해보세요.',
                style: textTheme.bodyMedium?.copyWith(
                  height: 1.55,
                  color: GoneColors.textSecondary,
                ),
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
                label: '학생 로그인',
                onPressed: () => onSelected(AccountRole.student),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => onSelected(AccountRole.teacher),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: GoneColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    '선생님 로그인',
                    style: textTheme.bodyMedium?.copyWith(
                      color: GoneColors.primary,
                    ),
                  ),
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
