import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gone/features/home/presentation/home_page.dart';

import '../../../core/design_system/gone_theme.dart';
import '../../auth/domain/account_role.dart';
import '../../camping_reservation/presentation/camping_reservation_page.dart';
import '../../lab_rental/presentation/lab_rental_page.dart';
import '../../lab_rental/presentation/teacher_lab_overview_page.dart';
import '../../my/presentation/my_page.dart';
import '../../outing/presentation/outing_page.dart';
import '../../point_system/presentation/point_system_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.role, this.onLogout});

  final AccountRole role;
  final VoidCallback? onLogout;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedTab = 0;

  void onChange(int tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  HomePage(role: widget.role),
                  widget.role == AccountRole.teacher
                      ? const TeacherLabOverviewPage()
                      : const LabRentalPage(showBottomNavigation: false),
                  const OutingPage(),
                  widget.role == AccountRole.teacher
                      ? const PointSystemPage()
                      : const CampingReservationPage(
                          showBottomNavigation: false,
                        ),
                  MyPage(onLogout: widget.onLogout ?? () {}),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _BottomNavigation(
                role: widget.role,
                selectedTab: _selectedTab,
                onChange: onChange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.role,
    required this.selectedTab,
    required this.onChange,
  });

  final AccountRole role;
  final int selectedTab;
  final ValueChanged<int> onChange;

  @override
  Widget build(BuildContext context) {
    final labels = [
      '홈',
      '실습실',
      '외출',
      role == AccountRole.teacher ? '상벌점' : '스쿨캠핑',
      '마이',
    ];
    final icons = [
      'home.svg',
      'lab.svg',
      'outing.svg',
      role == AccountRole.teacher ? 'point.svg' : 'camping.svg',
      'my.svg',
    ];

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(31),
        boxShadow: const [BoxShadow(color: GoneColors.gray100, blurRadius: 20)],
      ),
      child: Stack(
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 4),
            child: Container(
              margin: const EdgeInsets.all(2),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(31),
                gradient: const LinearGradient(
                  colors: [GoneColors.gray100, GoneColors.gray50],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Row(
              children: List.generate(labels.length, (index) {
                final selected = selectedTab == index;

                return Expanded(
                  child: Semantics(
                    button: true,
                    selected: selected,
                    label: labels[index],
                    child: InkWell(
                      onTap: () => onChange(index),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected
                              ? const Color(0xFFE7E7E8)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(26),
                        ),
                        child: Column(
                          spacing: 3,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18,
                              child: SvgPicture.asset(
                                'assets/icons/${icons[index]}',
                                colorFilter: ColorFilter.mode(
                                  selected
                                      ? GoneColors.primary
                                      : GoneColors.textSecondary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Text(
                              labels[index],
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: selected
                                    ? GoneColors.primary
                                    : GoneColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
