enum RentalStatus { submitted, waitingApproval, available }

class LabRoom {
  const LabRoom({
    required this.id,
    required this.floor,
    required this.number,
    required this.name,
    required this.capacity,
    required this.hasProjector,
    required this.isAvailable,
  });

  final String id;
  final int floor;
  final int number;
  final String name;
  final int capacity;
  final bool hasProjector;
  final bool isAvailable;
}

class LabRental {
  const LabRental({
    required this.id,
    required this.room,
    required this.dateLabel,
    required this.timeLabel,
    required this.leader,
    required this.memberCount,
    required this.purpose,
    required this.status,
  });

  final String id;
  final LabRoom room;
  final String dateLabel;
  final String timeLabel;
  final String leader;
  final int memberCount;
  final String purpose;
  final RentalStatus status;
}

const mockLabRooms = [
  LabRoom(
    id: 'lab-401',
    floor: 4,
    number: 1,
    name: 'NCS 응용 프로그래밍 실습실2',
    capacity: 20,
    hasProjector: true,
    isAvailable: true,
  ),
  LabRoom(
    id: 'lab-402',
    floor: 4,
    number: 2,
    name: 'NCS 게임콘텐츠 제작 실습실1',
    capacity: 20,
    hasProjector: true,
    isAvailable: true,
  ),
  LabRoom(
    id: 'lab-403',
    floor: 4,
    number: 3,
    name: 'SW 채움교실',
    capacity: 16,
    hasProjector: true,
    isAvailable: true,
  ),
  LabRoom(
    id: 'lab-406',
    floor: 4,
    number: 4,
    name: 'LAB 6실',
    capacity: 7,
    hasProjector: false,
    isAvailable: true,
  ),
  LabRoom(
    id: 'lab-407',
    floor: 4,
    number: 5,
    name: 'LAB 7실',
    capacity: 7,
    hasProjector: false,
    isAvailable: true,
  ),
];
