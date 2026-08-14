import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gone/features/lab_rental/application/lab_rental_notifier.dart';

void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('층 선택 시 해당 층의 첫 번째 실습실을 선택한다', () {
    final notifier = container.read(labRentalProvider.notifier);

    notifier.selectFloor(3);

    final state = container.read(labRentalProvider);
    expect(state.selectedFloor, 3);
    expect(state.selectedRoom.floor, 3);
    expect(state.roomsOnSelectedFloor, hasLength(1));
  });

  test('대여 신청 후 내 실습실 대여 화면으로 이동한다', () {
    final notifier = container.read(labRentalProvider.notifier);

    notifier.submit(leader: '김은찬', memberCount: 3, purpose: '캡스톤 프로젝트 진행');

    final state = container.read(labRentalProvider);
    expect(state.screen, LabRentalScreen.myRental);
    expect(state.rental?.leader, '김은찬');
    expect(state.rental?.memberCount, 3);
  });

  test('대여를 취소하면 목록 화면으로 돌아가고 신청 내역을 비운다', () {
    final notifier = container.read(labRentalProvider.notifier);
    notifier.submit(leader: '김은찬', memberCount: 3, purpose: '캡스톤 프로젝트 진행');

    notifier.cancelRental();

    final state = container.read(labRentalProvider);
    expect(state.screen, LabRentalScreen.rooms);
    expect(state.rental, isNull);
  });
}
