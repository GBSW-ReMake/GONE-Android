import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gone/core/design_system/gone_theme.dart';
import 'package:gone/features/home/application/profile_repository_provider.dart';

class ProfileCard extends ConsumerWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileRepositoryProvider);

    return profileAsync.when(
      error: (error, stackTrace) => const Center(child: Text('프로필을 불러오지 못했습니다.')),
      loading: () => const CircularProgressIndicator(color: GoneColors.primary),
      data: (profileData) => Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          spacing: 16,
          children: [
            Row(
              spacing: 10,
              children: [
                Text(
                  profileData.name,
                  style: TextTheme.of(context).bodyMedium?.copyWith(
                    color: GoneColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${profileData.grade}학년 ${profileData.classNo}반',
                  style: TextTheme.of(
                    context,
                  ).bodySmall?.copyWith(color: GoneColors.textSecondary),
                ),
              ],
            ),
            Row(
              spacing: 80,
              children: [
                _ProfileStat(
                  label: '상점',
                  value: '+${profileData.totalMeritPoints}',
                  color: GoneColors.primary,
                ),
                _ProfileStat(
                  label: '벌점',
                  value: '+${profileData.totalDemeritPoints}',
                  color: const Color(0xFFA7473D),
                ),
                _ProfileStat(
                  label: '현재 점수',
                  value: '+${profileData.netScore}',
                  color: GoneColors.textPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextTheme.of(context).labelSmall?.copyWith(
            color: GoneColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextTheme.of(
            context,
          ).bodyLarge?.copyWith(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
