import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_teacher_lab_overview_repository.dart';
import '../data/teacher_lab_overview_repository.dart';
import '../domain/teacher_lab_overview.dart';

enum TeacherLabOverviewStatus { initial, loading, loaded, empty, error }

class TeacherLabOverviewState {
  const TeacherLabOverviewState({
    required this.status,
    required this.selectedDate,
    required this.selectedFloor,
    this.rooms = const [],
    this.errorMessage,
  });

  final TeacherLabOverviewStatus status;
  final DateTime selectedDate;
  final int selectedFloor;
  final List<TeacherLabRoomStatus> rooms;
  final String? errorMessage;

  TeacherLabOverviewState copyWith({
    TeacherLabOverviewStatus? status,
    DateTime? selectedDate,
    int? selectedFloor,
    List<TeacherLabRoomStatus>? rooms,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TeacherLabOverviewState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedFloor: selectedFloor ?? this.selectedFloor,
      rooms: rooms ?? this.rooms,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class TeacherLabOverviewNotifier extends Notifier<TeacherLabOverviewState> {
  TeacherLabOverviewNotifier({TeacherLabOverviewRepository? repository})
    : _repository = repository ?? MockTeacherLabOverviewRepository();

  final TeacherLabOverviewRepository _repository;

  @override
  TeacherLabOverviewState build() => TeacherLabOverviewState(
    status: TeacherLabOverviewStatus.initial,
    selectedDate: DateTime(2026, 7, 29),
    selectedFloor: 4,
  );

  Future<void> load() async {
    state = state.copyWith(
      status: TeacherLabOverviewStatus.loading,
      clearError: true,
    );
    try {
      final rooms = await _repository.fetchOverview(
        date: state.selectedDate,
        floor: state.selectedFloor,
      );
      state = state.copyWith(
        status: rooms.isEmpty
            ? TeacherLabOverviewStatus.empty
            : TeacherLabOverviewStatus.loaded,
        rooms: rooms,
      );
    } catch (error) {
      state = state.copyWith(
        status: TeacherLabOverviewStatus.error,
        errorMessage: error.toString(),
      );
    }
  }

  Future<void> selectFloor(int floor) async {
    if (floor == state.selectedFloor &&
        state.status == TeacherLabOverviewStatus.loaded) {
      return;
    }
    state = state.copyWith(selectedFloor: floor);
    await load();
  }

  Future<void> selectDate(DateTime date) async {
    state = state.copyWith(selectedDate: date);
    await load();
  }
}

final teacherLabOverviewProvider =
    NotifierProvider<TeacherLabOverviewNotifier, TeacherLabOverviewState>(
      TeacherLabOverviewNotifier.new,
    );
