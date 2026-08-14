import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/design_system/gone_theme.dart';
import '../application/lab_rental_notifier.dart';
import '../domain/lab_rental.dart';
import 'lab_rental_form_page.dart';
import 'my_lab_rental_page.dart';

class LabRentalPage extends ConsumerWidget {
  const LabRentalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(labRentalProvider);
    if (state.screen == LabRentalScreen.form) {
      return const LabRentalFormPage();
    }
    if (state.screen == LabRentalScreen.myRental) {
      return const MyLabRentalPage();
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F9),
      body: SafeArea(child: const _LabRoomsView()),
      bottomNavigationBar: const _LabBottomNavigation(),
    );
  }
}

class _LabRoomsView extends ConsumerWidget {
  const _LabRoomsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(labRentalProvider);
    final controller = ref.read(labRentalProvider.notifier);
    final rooms = state.roomsOnSelectedFloor;

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 38, 28, 18),
      children: [
        const Text(
          '실습실 대여',
          style: TextStyle(fontSize: 14, color: Color(0xFF667085)),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            Text(
              '7',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: GoneColors.primary,
              ),
            ),
            Text(
              '월 ',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
            Text(
              '29',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: GoneColors.primary,
              ),
            ),
            Text(
              '일 실습실 예약',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _FloorTabs(
          selectedFloor: state.selectedFloor,
          onSelected: controller.selectFloor,
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Text(
              '${state.selectedFloor.toString()}층 실습실',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              '예약 가능 ${rooms.where((room) => room.isAvailable).length}개',
              style: const TextStyle(fontSize: 11, color: Color(0xFF667085)),
            ),
          ],
        ),
        const SizedBox(height: 13),
        for (final room in rooms) ...[
          _RoomCard(
            room: room,
            selected: room.id == state.selectedRoom.id,
            onTap: () => controller.selectRoom(room),
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 12),
        SizedBox(
          height: 54,
          child: FilledButton(
            onPressed: state.selectedRoom.isAvailable
                ? controller.showForm
                : null,
            style: FilledButton.styleFrom(
              backgroundColor: GoneColors.primary,
              disabledBackgroundColor: const Color(0xFFD0D5DD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13),
              ),
            ),
            child: Text(
              '${state.selectedRoom.name} 예약하기',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }
}

class _FloorTabs extends StatelessWidget {
  const _FloorTabs({required this.selectedFloor, required this.onSelected});
  final int selectedFloor;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFECEEF2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [4, 3, 2].map((floor) {
          final selected = floor == selectedFloor;
          return Expanded(
            child: InkWell(
              onTap: () => onSelected(floor),
              borderRadius: BorderRadius.circular(11),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: selected
                      ? const [
                          BoxShadow(
                            color: Color(0x0F101828),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  '$floor${'층'}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? const Color(0xFF1F2937)
                        : const Color(0xFF98A2B3),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.room,
    required this.selected,
    required this.onTap,
  });
  final LabRoom room;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${room.name}, ${room.isAvailable ? '예약 가능' : '예약 불가'}',
      child: InkWell(
        onTap: room.isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(17),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected ? GoneColors.primary : Colors.transparent,
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 36,
                child: Text(
                  '${room.number}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? GoneColors.primary
                        : const Color(0xFF98A2B3),
                  ),
                ),
              ),
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
              _AvailabilityBadge(available: room.isAvailable),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvailabilityBadge extends StatelessWidget {
  const _AvailabilityBadge({required this.available});
  final bool available;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    decoration: BoxDecoration(
      color: available ? const Color(0xFFF2F4F7) : const Color(0xFFFEE4E2),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Text(
      available ? '예약 가능' : '예약 불가',
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: available ? GoneColors.primary : const Color(0xFFD92D20),
      ),
    ),
  );
}

class _LabBottomNavigation extends StatelessWidget {
  const _LabBottomNavigation();

  @override
  Widget build(BuildContext context) {
    const labels = ['홈', '실습실', '외출', '스쿨캠핑', '설정'];
    const icons = [
      'home.svg',
      'lab.svg',
      'outing.svg',
      'camping.svg',
      'settings.svg',
    ];
    return SafeArea(
      top: false,
      child: Container(
        height: 68,
        margin: const EdgeInsets.fromLTRB(22, 0, 22, 12),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
        ),
        child: Row(
          children: List.generate(labels.length, (index) {
            final selected = index == 1;
            return Expanded(
              child: Semantics(
                button: true,
                selected: selected,
                label: labels[index],
                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFE9EDF4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/${icons[index]}',
                        width: 19,
                        height: 19,
                        colorFilter: ColorFilter.mode(
                          selected
                              ? GoneColors.primary
                              : const Color(0xFF667085),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected
                              ? GoneColors.primary
                              : const Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
