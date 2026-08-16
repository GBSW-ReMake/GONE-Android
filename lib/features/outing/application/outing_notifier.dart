import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/outing_request.dart';

enum OutingScreen { overview, form, detail, progress }

class OutingState {
  const OutingState({
    required this.screen,
    required this.selectedDate,
    required this.timeType,
    required this.timeRange,
    this.teacher,
    this.request,
  });

  final OutingScreen screen;
  final DateTime selectedDate;
  final OutingTimeType timeType;
  final OutingTimeRange timeRange;
  final OutingTeacher? teacher;
  final OutingRequest? request;

  bool get hasRequest => request != null;
  bool get isWaitingApproval => request?.status == OutingStatus.waitingApproval;
  bool get isApproved => request?.status == OutingStatus.approved;
  bool get isOuting => request?.status == OutingStatus.outing;

  OutingState copyWith({
    OutingScreen? screen,
    DateTime? selectedDate,
    OutingTimeType? timeType,
    OutingTimeRange? timeRange,
    OutingTeacher? teacher,
    OutingRequest? request,
    bool clearTeacher = false,
    bool clearRequest = false,
  }) => OutingState(
    screen: screen ?? this.screen,
    selectedDate: selectedDate ?? this.selectedDate,
    timeType: timeType ?? this.timeType,
    timeRange: timeRange ?? this.timeRange,
    teacher: clearTeacher ? null : teacher ?? this.teacher,
    request: clearRequest ? null : request ?? this.request,
  );
}

class OutingNotifier extends Notifier<OutingState> {
  @override
  OutingState build() => OutingState(
    screen: OutingScreen.overview,
    selectedDate: DateTime(2026, 8, 17),
    timeType: OutingTimeType.lunch,
    timeRange: lunchTimeRange,
  );

  void showOverview() => state = state.copyWith(screen: OutingScreen.overview);
  void showForm() => state = state.copyWith(screen: OutingScreen.form);
  void showDetail() {
    if (!state.hasRequest) return;
    state = state.copyWith(screen: OutingScreen.detail);
  }

  void showProgress() {
    if (!state.isApproved && !state.isOuting) return;
    state = state.copyWith(screen: OutingScreen.progress);
  }

  void selectDate(DateTime date) => state = state.copyWith(selectedDate: date);

  void selectTimeType(OutingTimeType type) {
    final range = switch (type) {
      OutingTimeType.lunch => lunchTimeRange,
      OutingTimeType.dinner => dinnerTimeRange,
      OutingTimeType.custom => state.timeRange,
    };
    state = state.copyWith(timeType: type, timeRange: range);
  }

  void setCustomTime({required int startMinute, required int endMinute}) {
    final range = OutingTimeRange(
      startMinute: startMinute,
      endMinute: endMinute,
    );
    if (!range.isValid) return;
    state = state.copyWith(timeType: OutingTimeType.custom, timeRange: range);
  }

  void selectTeacher(OutingTeacher teacher) =>
      state = state.copyWith(teacher: teacher);

  bool canSubmit(String reason) =>
      state.teacher != null &&
      reason.trim().isNotEmpty &&
      state.timeRange.isValid;

  bool submit(String reason) {
    if (!canSubmit(reason)) return false;
    state = state.copyWith(
      screen: OutingScreen.overview,
      request: OutingRequest(
        id: 'O-0817-01',
        date: state.selectedDate,
        timeType: state.timeType,
        timeRange: state.timeRange,
        teacher: state.teacher!,
        reason: reason.trim(),
        status: OutingStatus.waitingApproval,
      ),
    );
    return true;
  }

  bool update(String reason) {
    if (state.request == null ||
        !state.isWaitingApproval ||
        !canSubmit(reason)) {
      return false;
    }
    final request = state.request!;
    state = state.copyWith(
      screen: OutingScreen.detail,
      request: OutingRequest(
        id: request.id,
        date: state.selectedDate,
        timeType: state.timeType,
        timeRange: state.timeRange,
        teacher: state.teacher!,
        reason: reason.trim(),
        status: request.status,
      ),
    );
    return true;
  }

  void approveForPreview() {
    if (!state.isWaitingApproval) return;
    state = state.copyWith(
      screen: OutingScreen.progress,
      request: state.request!.copyWith(status: OutingStatus.approved),
    );
  }

  void startOuting() {
    if (!state.isApproved) return;
    state = state.copyWith(
      request: state.request!.copyWith(status: OutingStatus.outing),
    );
  }

  void endOuting() {
    if (!state.isOuting) return;
    state = state.copyWith(
      screen: OutingScreen.overview,
      clearRequest: true,
      clearTeacher: true,
    );
  }

  void cancel() => state = state.copyWith(
    screen: OutingScreen.overview,
    clearRequest: true,
    clearTeacher: true,
  );
}

final outingProvider = NotifierProvider<OutingNotifier, OutingState>(
  OutingNotifier.new,
);
