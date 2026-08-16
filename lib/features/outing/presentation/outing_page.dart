import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/outing_notifier.dart';
import '../domain/outing_request.dart';
import 'outing_form_page.dart';

class OutingPage extends ConsumerWidget {
  const OutingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.watch(outingProvider.select((state) => state.screen));
    return switch (screen) {
      OutingScreen.overview => const _OutingOverviewPage(),
      OutingScreen.form => const OutingFormPage(),
      OutingScreen.detail => const _OutingDetailPage(),
      OutingScreen.progress => const _OutingProgressPage(),
    };
  }
}

class _OutingOverviewPage extends ConsumerWidget {
  const _OutingOverviewPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outingProvider);
    final controller = ref.read(outingProvider.notifier);
    if (state.request != null) {
      return _RequestedOutingOverview(
        request: state.request!,
        onShowDetail: controller.showDetail,
        onShowForm: controller.showForm,
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 38, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '외출',
                style: TextStyle(fontSize: 11, color: Color(0xFF667085)),
              ),
              const SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                    letterSpacing: -0.6,
                  ),
                  children: [
                    TextSpan(
                      text:
                          '${state.selectedDate.month}월 ${state.selectedDate.day}일 ',
                      style: const TextStyle(color: GoneColors.primary),
                    ),
                    const TextSpan(text: '외출 신청'),
                  ],
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                '외출이 필요한가요?',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                '외출 날짜와 시간을 입력해 담당 선생님께\n승인을 요청할 수 있습니다.',
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF667085),
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/images/outing-apply-illustration.png',
                    width: 250,
                    height: 270,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: controller.showForm,
                  style: FilledButton.styleFrom(
                    backgroundColor: GoneColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('외출 신청'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestedOutingOverview extends StatelessWidget {
  const _RequestedOutingOverview({
    required this.request,
    required this.onShowDetail,
    required this.onShowForm,
  });

  final OutingRequest request;
  final VoidCallback onShowDetail;
  final VoidCallback onShowForm;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF3F5F9),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                '외출',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              '외출 신청',
              style: TextStyle(fontSize: 27, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            const Text(
              '이번 주 안에서만 신청할 수 있으며, 시간이 겹치지 않으면\n여러 건을 신청할 수 있어요.',
              style: TextStyle(
                fontSize: 15,
                height: 1.45,
                color: Color(0xFF667085),
              ),
            ),
            const SizedBox(height: 20),
            _OutingRequestCard(request: request, onTap: onShowDetail),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: onShowForm,
                style: FilledButton.styleFrom(
                  backgroundColor: GoneColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text('외출 신청'),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    ),
  );
}

class _OutingRequestCard extends StatelessWidget {
  const _OutingRequestCard({required this.request, required this.onTap});
  final OutingRequest request;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '외출 신청 상세 보기',
    child: SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const _StatusBadge(label: '승인 요청', color: GoneColors.warning),
              const SizedBox(height: 14),
              Text(
                '${request.date.month}월 ${request.date.day}일 외출',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                request.timeRange.label,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                request.reason,
                style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
              ),
              const SizedBox(height: 7),
              Text(
                '담당: ${request.teacher.label}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
              ),
              const SizedBox(height: 11),
              const Text(
                '신청 취소',
                style: TextStyle(
                  fontSize: 13,
                  color: GoneColors.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _OutingDetailPage extends ConsumerWidget {
  const _OutingDetailPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outingProvider);
    final request = state.request!;
    final controller = ref.read(outingProvider.notifier);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 18, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(
                title: '외출 상세',
                onBack: controller.showOverview,
                action: state.isWaitingApproval ? '수정' : null,
                onAction: controller.showForm,
              ),
              const SizedBox(height: 30),
              Align(
                alignment: Alignment.centerLeft,
                child: _StatusBadge(
                  label: state.isWaitingApproval ? '승인 요청' : '승인 완료',
                  color: state.isWaitingApproval
                      ? GoneColors.warning
                      : GoneColors.success,
                ),
              ),
              const SizedBox(height: 26),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F2937),
                  ),
                  children: [
                    TextSpan(text: '3206 '),
                    TextSpan(
                      text: '김은찬',
                      style: TextStyle(color: GoneColors.primary),
                    ),
                    TextSpan(text: ' 외출'),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              _DetailItem(label: '학적 정보', value: '3206'),
              _DetailItem(
                label: '날짜',
                value: '${request.date.month}월 ${request.date.day}일',
              ),
              _DetailItem(label: '시간', value: request.timeRange.label),
              _DetailItem(label: '사유', value: request.reason),
              _DetailItem(label: '지정 선생님', value: request.teacher.label),
              const Spacer(),
              if (state.isWaitingApproval) ...[
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: controller.cancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: GoneColors.error,
                      side: const BorderSide(color: GoneColors.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text('신청 취소'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: controller.approveForPreview,
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('승인 상태 미리보기'),
                ),
              ] else
                FilledButton(
                  onPressed: controller.showProgress,
                  child: const Text('외출 진행 화면 보기'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutingProgressPage extends ConsumerWidget {
  const _OutingProgressPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(outingProvider);
    final controller = ref.read(outingProvider.notifier);
    final outing = state.isOuting;
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '외출',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const Spacer(flex: 2),
              Text(
                outing ? '남은 시간' : '복귀 시간',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                outing
                    ? '30분'
                    : state.request!.timeRange.label.split(' ~ ').last,
                style: TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w700,
                  color: outing ? GoneColors.warning : GoneColors.primary,
                ),
              ),
              const SizedBox(height: 48),
              _HoldActionButton(
                label: outing ? '외출 종료' : '외출 시작',
                color: outing ? GoneColors.error : GoneColors.primary,
                onCompleted: outing
                    ? controller.endOuting
                    : controller.startOuting,
              ),
              const SizedBox(height: 28),
              Text(
                outing
                    ? '현재 위치와 이동 경로를\n선도부 학생에게 실시간으로 공유하고 있습니다.'
                    : '버튼을 1.5초간 길게 눌러\n외출을 시작해 주세요.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF667085),
                ),
              ),
              const Spacer(flex: 3),
              const Text(
                '위치 공유는 실제 서버 연동 전 목 상태로 표시됩니다.',
                style: TextStyle(fontSize: 11, color: Color(0xFF98A2B3)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HoldActionButton extends StatefulWidget {
  const _HoldActionButton({
    required this.label,
    required this.color,
    required this.onCompleted,
  });
  final String label;
  final Color color;
  final VoidCallback onCompleted;

  @override
  State<_HoldActionButton> createState() => _HoldActionButtonState();
}

class _HoldActionButtonState extends State<_HoldActionButton> {
  Timer? _timer;
  int _elapsed = 0;

  void _start() {
    _timer?.cancel();
    _elapsed = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      if (!mounted) return;
      setState(() => _elapsed += 50);
      if (_elapsed >= 1500) {
        timer.cancel();
        await HapticFeedback.mediumImpact();
        widget.onCompleted();
      }
    });
  }

  void _cancel() {
    _timer?.cancel();
    if (mounted) setState(() => _elapsed = 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${widget.label}, 1.5초 길게 누르기',
    child: GestureDetector(
      onTapDown: (_) => _start(),
      onTapUp: (_) => _cancel(),
      onTapCancel: _cancel,
      child: SizedBox(
        width: 132,
        height: 132,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            CircularProgressIndicator(
              value: _elapsed / 1500,
              strokeWidth: 5,
              color: Colors.white,
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      ),
    ),
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onBack,
    this.action,
    this.onAction,
  });
  final String title;
  final VoidCallback onBack;
  final String? action;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 58,
    child: Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(29),
          child: Ink(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFDCE1E8)),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 25),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        SizedBox(
          width: 78,
          height: 54,
          child: action == null
              ? null
              : OutlinedButton(
                  onPressed: onAction,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: GoneColors.primary,
                    side: const BorderSide(color: Color(0xFFDCE1E8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  child: Text(action!),
                ),
        ),
      ],
    ),
  );
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.14),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
    ),
  );
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF667085)),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
