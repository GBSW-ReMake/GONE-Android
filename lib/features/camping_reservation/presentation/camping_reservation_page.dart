import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/camping_reservation_notifier.dart';
import 'camping_calendar_page.dart';
import 'camping_reservation_complete_page.dart';
import 'camping_reservation_form_page.dart';

class CampingReservationPage extends ConsumerWidget {
  const CampingReservationPage({super.key, this.showBottomNavigation = true});

  final bool showBottomNavigation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = ref.watch(
      campingReservationProvider.select((state) => state.screen),
    );
    return switch (screen) {
      CampingReservationScreen.calendar => CampingCalendarPage(
        showBottomNavigation: showBottomNavigation,
      ),
      CampingReservationScreen.form => const CampingReservationFormPage(),
      CampingReservationScreen.complete =>
        const CampingReservationCompletePage(),
    };
  }
}
