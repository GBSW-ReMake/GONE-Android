import 'package:flutter/material.dart';

import '../../../core/design_system/gone_theme.dart';
import '../domain/point_system.dart';

class PointIssueCompletePage extends StatelessWidget {
  const PointIssueCompletePage({super.key, required this.records});
  final List<PointIssueRecord> records;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF3F5F9),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 42, 32, 20),
        child: Column(
          children: [
            Image.asset(
              'assets/images/point-check.png',
              width: 104,
              height: 104,
            ),
            const SizedBox(height: 24),
            const Text(
              '점수 발급이 완료되었습니다.',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: GoneColors.deepNavy,
              ),
            ),
            const SizedBox(height: 52),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '발급 명단',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: GoneColors.deepNavy,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: records.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final r = records[i];
                  final color = r.draft.kind == PointKind.reward
                      ? GoneColors.success
                      : GoneColors.error;
                  return Container(
                    height: 86,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${r.draft.kind.prefix}${r.draft.points}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: color,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    r.student.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    r.student.info,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF667085),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                r.draft.item,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(128, 52),
                    foregroundColor: GoneColors.error,
                    side: const BorderSide(color: GoneColors.error),
                  ),
                  child: const Text('취소'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: GoneColors.primary,
                    ),
                    child: const Text('확인'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
