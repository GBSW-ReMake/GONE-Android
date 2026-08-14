import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/lab_rental.dart';

enum LabRentalScreen { rooms, form, myRental }

class LabRentalState {
  const LabRentalState({
    required this.selectedFloor,
    required this.selectedRoom,
    required this.screen,
    this.rental,
  });

  final int selectedFloor;
  final LabRoom selectedRoom;
  final LabRentalScreen screen;
  final LabRental? rental;

  List<LabRoom> get roomsOnSelectedFloor =>
      mockLabRooms.where((room) => room.floor == selectedFloor).toList();

  LabRentalState copyWith({
    int? selectedFloor,
    LabRoom? selectedRoom,
    LabRentalScreen? screen,
    LabRental? rental,
    bool clearRental = false,
  }) {
    return LabRentalState(
      selectedFloor: selectedFloor ?? this.selectedFloor,
      selectedRoom: selectedRoom ?? this.selectedRoom,
      screen: screen ?? this.screen,
      rental: clearRental ? null : rental ?? this.rental,
    );
  }
}

class LabRentalNotifier extends Notifier<LabRentalState> {
  @override
  LabRentalState build() => LabRentalState(
    selectedFloor: 4,
    selectedRoom: mockLabRooms.first,
    screen: LabRentalScreen.rooms,
  );

  void selectFloor(int floor) {
    final rooms = mockLabRooms.where((room) => room.floor == floor).toList();
    if (rooms.isEmpty) return;
    state = state.copyWith(selectedFloor: floor, selectedRoom: rooms.first);
  }

  void selectRoom(LabRoom room) => state = state.copyWith(selectedRoom: room);
  void showForm() => state = state.copyWith(screen: LabRentalScreen.form);
  void showRooms() => state = state.copyWith(screen: LabRentalScreen.rooms);
  void showMyRental() =>
      state = state.copyWith(screen: LabRentalScreen.myRental);

  void submit({
    required String leader,
    required int memberCount,
    required String purpose,
  }) {
    final rental = LabRental(
      id: 'R-0720-06',
      room: state.selectedRoom,
      dateLabel: '7월 30일 목요일',
      timeLabel: '19:10 ~ 20:30',
      leader: leader,
      memberCount: memberCount,
      purpose: purpose,
      status: RentalStatus.submitted,
    );
    state = state.copyWith(screen: LabRentalScreen.myRental, rental: rental);
  }

  void cancelRental() =>
      state = state.copyWith(screen: LabRentalScreen.rooms, clearRental: true);
}

final labRentalProvider = NotifierProvider<LabRentalNotifier, LabRentalState>(
  LabRentalNotifier.new,
);
