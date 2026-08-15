import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/lab_rental_notifier.dart';

class LabRentalFormPage extends ConsumerStatefulWidget {
  const LabRentalFormPage({super.key});

  @override
  ConsumerState<LabRentalFormPage> createState() => _LabRentalFormPageState();
}

class _LabRentalFormPageState extends ConsumerState<LabRentalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _leaderController = TextEditingController();
  final _membersController = TextEditingController();
  final _purposeController = TextEditingController();

  @override
  void dispose() {
    _leaderController.dispose();
    _membersController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final members = _membersController.text
        .split(',')
        .where((member) => member.trim().isNotEmpty)
        .length;
    ref
        .read(labRentalProvider.notifier)
        .submit(
          leader: _leaderController.text.trim(),
          memberCount: members,
          purpose: _purposeController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(labRentalProvider);
    final room = state.selectedRoom;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: ref.read(labRentalProvider.notifier).showRooms,
                    tooltip: '실습실 목록으로 돌아가기',
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        '실습실 대여',
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
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Text(
                      '${room.floor}층',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: GoneColors.primary,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '최대 ${room.capacity}명${room.hasProjector ? ' · 빔프로젝터' : ''}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF667085),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const _FormLabel('대표자'),
              const SizedBox(height: 10),
              _InputField(
                controller: _leaderController,
                hint: '대표자 이름을 입력해주세요',
                validator: (value) => value == null || value.trim().isEmpty
                    ? '대표자를 입력해주세요.'
                    : null,
              ),
              const SizedBox(height: 22),
              const _FormLabel('사용 인원 명단', suffix: '본인포함'),
              const SizedBox(height: 10),
              _InputField(
                controller: _membersController,
                hint: '예) 3206김은찬, 3218정문경',
                maxLines: 4,
                validator: (value) {
                  final count =
                      value
                          ?.split(',')
                          .where((member) => member.trim().isNotEmpty)
                          .length ??
                      0;
                  if (count == 0) {
                    return '사용 인원을 한 명 이상 입력해주세요.';
                  }
                  if (count > room.capacity) {
                    return '최대 ${room.capacity}명까지 신청할 수 있어요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 22),
              const _FormLabel('사용 목적'),
              const SizedBox(height: 10),
              _InputField(
                controller: _purposeController,
                hint: '실습실 사용 목적을 입력해주세요',
                maxLines: 5,
                validator: (value) => value == null || value.trim().isEmpty
                    ? '사용 목적을 입력해주세요.'
                    : null,
              ),
              const SizedBox(height: 26),
              SizedBox(
                height: 54,
                child: FilledButton(
                  onPressed: _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: GoneColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    '대여 신청하기',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormLabel extends StatelessWidget {
  const _FormLabel(this.label, {this.suffix});
  final String label;
  final String? suffix;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
      if (suffix != null) ...[
        const SizedBox(width: 9),
        Text(
          suffix!,
          style: const TextStyle(fontSize: 11, color: Color(0xFF667085)),
        ),
      ],
    ],
  );
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    required this.validator,
    this.maxLines = 1,
  });
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  final int maxLines;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    validator: validator,
    maxLines: maxLines,
    keyboardType: TextInputType.text,
    textCapitalization: TextCapitalization.none,
    enableSuggestions: true,
    autocorrect: false,
    textInputAction: maxLines == 1
        ? TextInputAction.next
        : TextInputAction.newline,
    style: const TextStyle(fontSize: 13),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF98A2B3)),
      contentPadding: const EdgeInsets.all(17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: GoneColors.primary, width: 2),
      ),
    ),
  );
}
