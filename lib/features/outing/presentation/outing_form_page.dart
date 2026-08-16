import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/outing_notifier.dart';
import '../domain/outing_request.dart';

class OutingFormPage extends ConsumerStatefulWidget {
  const OutingFormPage({super.key});

  @override
  ConsumerState<OutingFormPage> createState() => _OutingFormPageState();
}

class _OutingFormPageState extends ConsumerState<OutingFormPage> {
  late final TextEditingController _reasonController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController(
      text: ref.read(outingProvider).request?.reason ?? '',
    );
    _reasonController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(outingProvider);
    final controller = ref.read(outingProvider.notifier);
    final isEditing = state.request != null;
    final canSubmit = controller.canSubmit(_reasonController.text);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(28, 18, 28, 30),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: controller.showOverview,
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      isEditing ? '외출 수정' : '외출 신청',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 24),
            const _InfoBanner(),
            const SizedBox(height: 28),
            const _SectionTitle('외출 날짜'),
            const SizedBox(height: 10),
            _DateField(
              date: state.selectedDate,
              onTap: () => _pickDate(context, controller, state.selectedDate),
            ),
            const SizedBox(height: 26),
            const _SectionTitle('시간 선택'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _TimeTypeButton(
                    label: '점심',
                    selected: state.timeType == OutingTimeType.lunch,
                    onTap: () =>
                        controller.selectTimeType(OutingTimeType.lunch),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TimeTypeButton(
                    label: '저녁',
                    selected: state.timeType == OutingTimeType.dinner,
                    onTap: () =>
                        controller.selectTimeType(OutingTimeType.dinner),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _TimeTypeButton(
                    label: '직접 설정',
                    selected: state.timeType == OutingTimeType.custom,
                    onTap: () =>
                        controller.selectTimeType(OutingTimeType.custom),
                  ),
                ),
              ],
            ),
            if (state.timeType == OutingTimeType.custom) ...[
              const SizedBox(height: 16),
              _CustomTimeCard(
                range: state.timeRange,
                onTap: () =>
                    _pickCustomTime(context, controller, state.timeRange),
              ),
            ] else ...[
              const SizedBox(height: 9),
              Text(
                state.timeRange.label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
              ),
            ],
            const SizedBox(height: 28),
            const _SectionTitle('담당 선생님'),
            const SizedBox(height: 10),
            _TeacherField(
              teacher: state.teacher,
              onTap: () => _showTeacherSearch(context, controller),
            ),
            const SizedBox(height: 28),
            const _SectionTitle('외출 사유'),
            const SizedBox(height: 10),
            TextField(
              controller: _reasonController,
              minLines: 4,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: '외출 사유를 입력해 주세요',
                hintStyle: const TextStyle(color: Color(0xFF98A2B3)),
                filled: true,
                fillColor: Colors.white,
                border: _border(),
                enabledBorder: _border(),
                focusedBorder: _border(color: GoneColors.primary),
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 54,
              child: FilledButton(
                onPressed: canSubmit
                    ? () {
                        final success = isEditing
                            ? controller.update(_reasonController.text)
                            : controller.submit(_reasonController.text);
                        if (success) FocusScope.of(context).unfocus();
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: GoneColors.primary,
                  disabledBackgroundColor: const Color(0xFFA5C2F5),
                  disabledForegroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(isEditing ? '외출 수정' : '외출 신청하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  OutlineInputBorder _border({Color color = const Color(0xFFD0D5DD)}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: color),
      );

  Future<void> _pickDate(
    BuildContext context,
    OutingNotifier controller,
    DateTime initial,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2026, 1),
      lastDate: DateTime(2027),
    );
    if (date != null) controller.selectDate(date);
  }

  Future<void> _pickCustomTime(
    BuildContext context,
    OutingNotifier controller,
    OutingTimeRange range,
  ) async {
    final start = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: range.startMinute ~/ 60,
        minute: range.startMinute % 60,
      ),
    );
    if (start == null || !context.mounted) return;
    final end = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: range.endMinute ~/ 60,
        minute: range.endMinute % 60,
      ),
    );
    if (end == null) return;
    controller.setCustomTime(
      startMinute: start.hour * 60 + start.minute,
      endMinute: end.hour * 60 + end.minute,
    );
  }

  void _showTeacherSearch(BuildContext context, OutingNotifier controller) =>
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) =>
            _TeacherSearchSheet(onSelected: controller.selectTeacher),
      );
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: GoneColors.softBlue,
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Text(
      '신청 가능 기간: 이번 주 · 가능 시간: 오전 08:40 ~ 오후 08:30',
      style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
  );
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});
  final DateTime date;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Ink(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Row(
        children: [
          Text(
            '${date.month}월 ${date.day}일',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Icon(Icons.calendar_month_outlined, color: Color(0xFF667085)),
        ],
      ),
    ),
  );
}

class _TimeTypeButton extends StatelessWidget {
  const _TimeTypeButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 48,
    child: OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: selected ? Colors.white : GoneColors.primary,
        backgroundColor: selected ? GoneColors.primary : Colors.white,
        side: BorderSide(
          color: selected ? GoneColors.primary : const Color(0xFFC7D7FA),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      ),
      child: Text(label),
    ),
  );
}

class _CustomTimeCard extends StatelessWidget {
  const _CustomTimeCard({required this.range, required this.onTap});
  final OutingTimeRange range;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Ink(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Text('직접 시간 설정', style: TextStyle(fontWeight: FontWeight.w700)),
          const Spacer(),
          Text(
            range.label,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: GoneColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.edit_outlined, size: 18),
        ],
      ),
    ),
  );
}

class _TeacherField extends StatelessWidget {
  const _TeacherField({required this.teacher, required this.onTap});
  final OutingTeacher? teacher;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Ink(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Row(
        children: [
          Text(
            teacher?.label ?? '선생님 검색',
            style: TextStyle(
              fontSize: 16,
              color: teacher == null
                  ? const Color(0xFF98A2B3)
                  : const Color(0xFF1F2937),
            ),
          ),
          const Spacer(),
          const Icon(Icons.search, color: Color(0xFF667085)),
        ],
      ),
    ),
  );
}

class _TeacherSearchSheet extends StatefulWidget {
  const _TeacherSearchSheet({required this.onSelected});

  final ValueChanged<OutingTeacher> onSelected;

  @override
  State<_TeacherSearchSheet> createState() => _TeacherSearchSheetState();
}

class _TeacherSearchSheetState extends State<_TeacherSearchSheet> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final teachers = mockOutingTeachers.where(
      (teacher) => teacher.name.contains(query) || teacher.id.contains(query),
    );
    return SafeArea(
      child: Container(
        height: MediaQuery.sizeOf(context).height * .62,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('닫기'),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      '선생님 검색',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            TextField(
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: '이름으로 검색',
                filled: true,
                fillColor: const Color(0xFFF3F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  for (final teacher in teachers)
                    ListTile(
                      title: Text(teacher.label),
                      subtitle: Text(teacher.id),
                      trailing: const Icon(
                        Icons.add_circle,
                        color: GoneColors.primary,
                      ),
                      onTap: () {
                        widget.onSelected(teacher);
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
