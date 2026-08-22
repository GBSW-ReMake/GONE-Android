import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/point_system_notifier.dart';
import '../domain/point_system.dart';
import 'point_issue_complete_page.dart';
import 'point_issue_form_page.dart';

class PointSystemPage extends ConsumerStatefulWidget {
  const PointSystemPage({super.key});

  @override
  ConsumerState<PointSystemPage> createState() => _PointSystemPageState();
}

class _PointSystemPageState extends ConsumerState<PointSystemPage> {
  int _section = 0;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pointSystemProvider);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '상벌점 시스템',
                style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
              ),
              const SizedBox(height: 6),
              const Text(
                '상벌점 점수 발급',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: GoneColors.deepNavy,
                ),
              ),
              const SizedBox(height: 22),
              _SectionTabs(
                selected: _section,
                onChanged: (value) => setState(() => _section = value),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: switch (_section) {
                  0 => _IssueTab(state: state),
                  1 => _HistoryTab(records: state.records),
                  _ => _StatisticsTab(records: state.records),
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['점수발급', '발급 내역', '통계'];
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE9ECF1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final active = selected == index;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(index),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: active
                      ? const [
                          BoxShadow(
                            color: Color(0x18000000),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    color: active
                        ? GoneColors.primary
                        : const Color(0xFF667085),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _IssueTab extends ConsumerWidget {
  const _IssueTab({required this.state});

  final PointSystemState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(pointSystemProvider.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: state.students.isEmpty
              ? _EmptyIssueState(onAdd: () => _pickStudent(context, controller))
              : ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const Text(
                      '발급 명단',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: GoneColors.deepNavy,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...state.students.map(
                      (student) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _StudentCard(
                          student: student,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  PointIssueFormPage(student: student),
                            ),
                          ),
                          onRemove: () => controller.removeStudent(student),
                        ),
                      ),
                    ),
                    _AddTargetButton(
                      onTap: () => _pickStudent(context, controller),
                    ),
                  ],
                ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            OutlinedButton(
              onPressed: controller.clear,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(112, 52),
                foregroundColor: GoneColors.error,
                side: const BorderSide(color: GoneColors.error),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('전체 삭제'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: state.students.isEmpty
                    ? null
                    : () {
                        final records = controller.issueAll();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                PointIssueCompletePage(records: records),
                          ),
                        );
                      },
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: GoneColors.primary,
                  disabledBackgroundColor: const Color(0xFFD4D7DD),
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('점수 발급'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _pickStudent(BuildContext context, PointSystemNotifier controller) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: mockPointStudents
              .map(
                (student) => ListTile(
                  title: Text('${student.id} ${student.name}'),
                  subtitle: Text(student.info),
                  trailing: const Icon(
                    Icons.add_circle,
                    color: GoneColors.primary,
                  ),
                  onTap: () {
                    controller.addStudent(student);
                    Navigator.pop(sheetContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PointIssueFormPage(student: student),
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _EmptyIssueState extends StatelessWidget {
  const _EmptyIssueState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 56),
        Image.asset('assets/images/point-plus.png', width: 104, height: 104),
        const SizedBox(height: 22),
        const Text(
          '발급 대상자를 추가해 주세요',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: GoneColors.deepNavy,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '학생을 선택한 뒤 항목과 점수를 지정합니다.',
          style: TextStyle(fontSize: 15, color: Color(0xFF667085)),
        ),
        const SizedBox(height: 26),
        _AddTargetButton(onTap: onAdd, width: 280),
      ],
    );
  }
}

class _AddTargetButton extends StatelessWidget {
  const _AddTargetButton({required this.onTap, this.width});

  final VoidCallback onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: GoneColors.primary,
          side: const BorderSide(color: GoneColors.primary, width: 1.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          '+ 발급 대상자 추가',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _StudentCard extends StatelessWidget {
  const _StudentCard({
    required this.student,
    required this.onTap,
    required this.onRemove,
  });

  final PointStudent student;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 76,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Text(
                        student.info,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: onRemove,
                icon: const Icon(Icons.close, size: 22),
                splashRadius: 22,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryTab extends StatefulWidget {
  const _HistoryTab({required this.records});

  final List<PointIssueRecord> records;

  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  PointKind? _filter;

  @override
  Widget build(BuildContext context) {
    final records = _filter == null
        ? widget.records
        : widget.records.where((r) => r.draft.kind == _filter).toList();
    return Column(
      children: [
        Row(
          children: [
            _FilterChip(
              label: '전체',
              active: _filter == null,
              onTap: () => _setFilter(null),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: '상점',
              active: _filter == PointKind.reward,
              onTap: () => _setFilter(PointKind.reward),
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: '벌점',
              active: _filter == PointKind.penalty,
              onTap: () => _setFilter(PointKind.penalty),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: records.isEmpty
              ? const Center(child: Text('발급 내역이 없어요'))
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, index) =>
                      _HistoryCard(record: records[index]),
                ),
        ),
      ],
    );
  }

  void _setFilter(PointKind? filter) => setState(() => _filter = filter);
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? GoneColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : const Color(0xFF667085),
            ),
          ),
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.record});

  final PointIssueRecord record;

  @override
  Widget build(BuildContext context) {
    final color = record.draft.kind == PointKind.reward
        ? GoneColors.success
        : GoneColors.error;
    final date =
        '${record.issuedAt.year}년 ${record.issuedAt.month}월 ${record.issuedAt.day}일';
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            child: Text(
              '${record.draft.kind.prefix}${record.draft.points}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      record.student.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      record.student.info,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF667085),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  record.draft.item,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 24),
        ],
      ),
    );
  }
}

class _StatisticsTab extends StatelessWidget {
  const _StatisticsTab({required this.records});

  final List<PointIssueRecord> records;

  @override
  Widget build(BuildContext context) {
    final reward = records
        .where((record) => record.draft.kind == PointKind.reward)
        .fold<int>(0, (sum, record) => sum + record.draft.points);
    final penalty = records
        .where((record) => record.draft.kind == PointKind.penalty)
        .fold<int>(0, (sum, record) => sum + record.draft.points);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '내 발급 통계',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: GoneColors.deepNavy,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            _StatCard(
              title: '이번 달 발급',
              value: '${records.length}',
              suffix: '건',
              color: GoneColors.primary,
            ),
            const SizedBox(width: 10),
            _StatCard(
              title: '발급한 상점',
              value: '$reward',
              suffix: '점',
              color: GoneColors.success,
            ),
            const SizedBox(width: 10),
            _StatCard(
              title: '발급한 벌점',
              value: '$penalty',
              suffix: '점',
              color: GoneColors.error,
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          '현재 로그인한 선생님의 발급 기록 기준',
          style: TextStyle(fontSize: 16, color: Color(0xFF667085)),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.suffix,
    required this.color,
  });

  final String title;
  final String value;
  final String suffix;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 108,
        padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 36,
                    height: .9,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  suffix,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
