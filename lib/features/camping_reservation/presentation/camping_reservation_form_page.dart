import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/camping_reservation_notifier.dart';
import '../domain/camping_reservation.dart';

class CampingReservationFormPage extends ConsumerWidget {
  const CampingReservationFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(campingReservationProvider);
    final controller = ref.read(campingReservationProvider.notifier);
    final date = state.selectedDate!;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: controller.showCalendar,
                  tooltip: '달력으로 돌아가기',
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      '예약',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 32),
            _SelectedDateCard(date: date),
            const SizedBox(height: 24),
            const Text(
              '담당 선생님',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            _SearchField(
              hint: state.teacher?.label ?? '선생님 검색',
              onTap: () =>
                  _openSearchSheet(context, ref, ParticipantRole.teacher),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Text(
                  '사용 인원',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                ),
                const SizedBox(width: 9),
                const Text(
                  '본인포함',
                  style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
                ),
                const Spacer(),
                Text(
                  '${state.students.length} / 8명',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...state.students.map(
                  (student) => _PersonChip(
                    participant: student,
                    onDeleted: () => controller.removeStudent(student.id),
                  ),
                ),
                _AddPersonButton(
                  enabled: state.students.length < 8,
                  onTap: () =>
                      _openSearchSheet(context, ref, ParticipantRole.student),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '학생을 검색해 추가할 수 있습니다. 최대 8명까지 예약할 수 있습니다.',
              style: TextStyle(fontSize: 11, color: Color(0xFF667085)),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: state.canSubmit ? controller.submit : null,
                style: FilledButton.styleFrom(
                  backgroundColor: GoneColors.primary,
                  disabledBackgroundColor: const Color(0xFFA5C2F5),
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  '예약하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSearchSheet(
    BuildContext context,
    WidgetRef ref,
    ParticipantRole role,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ParticipantSearchSheet(role: role),
    );
  }
}

class _SelectedDateCard extends StatelessWidget {
  const _SelectedDateCard({required this.date});
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCE1E8)),
      ),
      child: Row(
        children: [
          const Text(
            '선택한 날짜',
            style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
          ),
          const Spacer(),
          Text(
            '${date.year}년 ${date.month}월 ${date.day}일 ${weekdays[date.weekday - 1]}요일',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.hint, required this.onTap});
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: hint,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: const Color(0xFFD0D5DD)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(
                    fontSize: 14,
                    color: hint.contains('검색')
                        ? const Color(0xFF98A2B3)
                        : const Color(0xFF1F2937),
                  ),
                ),
              ),
              const Icon(Icons.search, color: Color(0xFF667085)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonChip extends StatelessWidget {
  const _PersonChip({required this.participant, required this.onDeleted});
  final Participant participant;
  final VoidCallback onDeleted;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 7, 7, 7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFD0D5DD)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          participant.id,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 14),
        Text(
          participant.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        IconButton(
          onPressed: onDeleted,
          icon: const Icon(Icons.close, size: 16, color: Color(0xFF98A2B3)),
          padding: const EdgeInsets.all(4),
          constraints: const BoxConstraints.tightFor(width: 28, height: 28),
          tooltip: '${participant.name} 삭제',
        ),
      ],
    ),
  );
}

class _AddPersonButton extends StatelessWidget {
  const _AddPersonButton({required this.enabled, required this.onTap});
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '학생 추가',
    child: InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF7D90B3),
            style: BorderStyle.solid,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Color(0xFF667085)),
            SizedBox(width: 8),
            Text(
              '인원 추가',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF667085),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ParticipantSearchSheet extends ConsumerStatefulWidget {
  const _ParticipantSearchSheet({required this.role});
  final ParticipantRole role;

  @override
  ConsumerState<_ParticipantSearchSheet> createState() =>
      _ParticipantSearchSheetState();
}

class _ParticipantSearchSheetState
    extends ConsumerState<_ParticipantSearchSheet> {
  final _queryController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final people = widget.role == ParticipantRole.teacher
        ? mockTeachers
        : mockStudents;
    final filtered = people
        .where(
          (person) =>
              person.id.contains(_query) || person.name.contains(_query),
        )
        .toList();
    final title = widget.role == ParticipantRole.teacher ? '선생님 검색' : '학생 검색';
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.92,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 22),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFD0D5DD),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 17),
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _queryController,
              keyboardType: TextInputType.text,
              onChanged: (value) => setState(() => _query = value.trim()),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: widget.role == ParticipantRole.teacher
                    ? '이름 검색'
                    : '학번 또는 이름 검색',
                filled: true,
                fillColor: const Color(0xFFF2F4F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(13),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: filtered.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final person = filtered[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    title: Text(
                      person.label,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: const Text(
                      '참여자 추가',
                      style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
                    ),
                    trailing: const Icon(
                      Icons.add_circle,
                      color: GoneColors.primary,
                    ),
                    onTap: () {
                      final controller = ref.read(
                        campingReservationProvider.notifier,
                      );
                      if (widget.role == ParticipantRole.teacher) {
                        controller.selectTeacher(person);
                      } else {
                        controller.addStudent(person);
                      }
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
