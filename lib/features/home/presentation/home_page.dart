import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gone/core/app_widgets.dart';
import 'package:gone/features/home/presentation/widgets/profile_card.dart';

import '../../../core/design_system/gone_theme.dart';
import '../../auth/domain/account_role.dart';
import '../../notification/application/notification_notifier.dart';
import '../../notification/presentation/notification_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.role});

  final AccountRole role;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _scheduleController = PageController();
  final PageController _mealController = PageController();

  int get _schedulePage =>
      _scheduleController.hasClients ? _scheduleController.page!.round() : 0;

  int get _mealPage =>
      _mealController.hasClients ? _mealController.page!.round() : 0;
  int _month = 8;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(notificationProvider.notifier).load(widget.role),
    );
  }

  @override
  void dispose() {
    _scheduleController.dispose();
    _mealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = ref.watch(
      notificationProvider.select(
        (state) => state.role == widget.role ? state.unreadCount : 0,
      ),
    );
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F4F7),
        titleSpacing: 24,
        title: const GoneLogo(width: 77),
        actions: [
          Semantics(
            button: true,
            label: '알림',
            child: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => NotificationPage(role: widget.role),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              style: IconButton.styleFrom(overlayColor: Colors.transparent),
              icon: Badge(
                backgroundColor: unreadCount == 0
                    ? Colors.transparent
                    : Colors.red,
                child: SizedBox(
                  width: 20,
                  child: SvgPicture.asset(
                    'assets/icons/bell.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(child: _home()),
    );
  }

  Widget _home() => ListView(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
    children: const [
      ProfileCard(),
    ],
  );

  // Widget _home(int unreadCount) {
  //   return ListView(
  //     padding: const EdgeInsets.fromLTRB(26, 24, 26, 20),
  //     children: [
  //       _profileCard(showPointSummary: widget.role == AccountRole.student),
  //       const SizedBox(height: 18),
  //       _sectionHeader(
  //         icon: 'assets/images/section-schedule.png',
  //         title: '오늘 시간표',
  //         count: '${_schedulePage + 1} / 7',
  //       ),
  //       const SizedBox(height: 12),
  //       SizedBox(
  //         height: 114,
  //         child: PageView(
  //           controller: _scheduleController,
  //           onPageChanged: (index) => setState(() => _schedulePage = index),
  //           children: const [
  //             _ScheduleCard(
  //               period: '6',
  //               subject: '네트워크',
  //               time: '13:30–14:20',
  //               next: '7교시 · 웹 프로그래밍',
  //               room: '웹 개발실',
  //             ),
  //             _ScheduleCard(
  //               period: '7',
  //               subject: '웹 프로그래밍',
  //               time: '14:30–15:20',
  //               next: '8교시 · 데이터베이스',
  //               room: '소프트웨어 2실',
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 20),
  //       _sectionHeader(
  //         icon: 'assets/images/section-meal.png',
  //         title: '오늘 급식',
  //         count: '${_mealPage + 1} / 3',
  //       ),
  //       const SizedBox(height: 12),
  //       SizedBox(
  //         height: 214,
  //         child: PageView(
  //           controller: _mealController,
  //           onPageChanged: (index) => setState(() => _mealPage = index),
  //           children: const [
  //             _MealCard(
  //               meal: '아침',
  //               time: '07:30–08:30',
  //               leftMenu: '흰쌀밥\n소고기무국\n계란찜',
  //               rightMenu: '김치\n딸기우유\n요구르트',
  //               calorie: '620 kcal',
  //             ),
  //             _MealCard(
  //               meal: '점심',
  //               time: '12:20–13:20',
  //               leftMenu: '현미밥\n쇠고기미역국 (5.6.16)\n돼지갈비찜 (5.6.10.13)\n깻잎양념무침',
  //               rightMenu:
  //                   '쌀배추무생채(해고) (5.6.13)\n잡채 (5.6.13.16.18)\n배추김치 (9)\n미숫가루수박화채 (2.5.13)',
  //               calorie: '785 kcal',
  //             ),
  //             _MealCard(
  //               meal: '저녁',
  //               time: '17:30–18:30',
  //               leftMenu: '잡곡밥\n된장국\n닭갈비',
  //               rightMenu: '콩나물무침\n배추김치\n요구르트',
  //               calorie: '720 kcal',
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 22),
  //       _academicSection(),
  //       const SizedBox(height: 20),
  //       _titleWithIcon('assets/images/section-request.png', '신청현황'),
  //       const SizedBox(height: 12),
  //       const _RequestCard(
  //         image: 'assets/images/home-lab.png',
  //         title: '실습실 신청',
  //         detail: '오늘 19:00–21:00 iOS실',
  //         status: '신청 완료',
  //         statusColor: Color(0xFF5B8DEF),
  //       ),
  //       const SizedBox(height: 10),
  //       const _RequestCard(
  //         image: 'assets/images/home-outing.png',
  //         title: '외출 신청',
  //         detail: '7월 22일 · 병원 방문',
  //         status: '승인대기',
  //         statusColor: Color(0xFFB77A19),
  //       ),
  //       const SizedBox(height: 10),
  //       const _RequestCard(
  //         image: 'assets/images/home-camping.png',
  //         title: '스쿨캠핑 예약',
  //         detail: '7월 24일 금요일 · 4명',
  //         status: '예약 완료',
  //         statusColor: Color(0xFF5B8DEF),
  //       ),
  //     ],
  //   );
  // }

  Widget _sectionHeader({
    required String icon,
    required String title,
    required String count,
  }) {
    return Row(
      children: [
        Image.asset(icon, width: 21, height: 21, fit: BoxFit.contain),
        const SizedBox(width: 8),
        Text(title, style: _text(size: 18, weight: FontWeight.w700)),
        const Spacer(),
        Text(count, style: _text(size: 12, color: const Color(0xFF667085))),
      ],
    );
  }

  Widget _titleWithIcon(String icon, String title) {
    return Row(
      children: [
        Image.asset(icon, width: 21, height: 21, fit: BoxFit.contain),
        const SizedBox(width: 8),
        Text(title, style: _text(size: 18, weight: FontWeight.w700)),
      ],
    );
  }

  Widget _academicSection() {
    const events = [
      ('08.01 토', '토요휴업일'),
      ('08.08 토', '토요휴업일'),
      ('08.10 월', '개학식'),
      ('08.15 토', '광복절'),
    ];
    final hasEvents = _month == 8;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/section-academic.png',
              width: 21,
              height: 21,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text('학사일정', style: _text(size: 18, weight: FontWeight.w700)),
            const SizedBox(width: 9),
            Text(
              '2026년 $_month월',
              style: _text(size: 12, color: const Color(0xFF667085)),
            ),
            const Spacer(),
            _roundButton(Icons.chevron_left, () => setState(() => _month--)),
            const SizedBox(width: 10),
            _roundButton(Icons.chevron_right, () => setState(() => _month++)),
          ],
        ),
        const SizedBox(height: 12),
        if (!hasEvents)
          _surface(
            radius: 15,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 19),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 21,
                  color: Color(0xFF667085),
                ),
                const SizedBox(width: 12),
                Text(
                  '등록된 학사일정이 없어요',
                  style: _text(size: 14, color: const Color(0xFF667085)),
                ),
              ],
            ),
          )
        else
          for (final event in events) ...[
            _surface(
              radius: 15,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
              child: Row(
                children: [
                  SizedBox(
                    width: 69,
                    child: Text(
                      event.$1,
                      style: _text(
                        size: 14,
                        weight: FontWeight.w700,
                        color: GoneColors.primary,
                      ),
                    ),
                  ),
                  Text(
                    event.$2,
                    style: _text(size: 14, weight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 9),
          ],
      ],
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Ink(
        width: 46,
        height: 46,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 27, color: const Color(0xFF344054)),
      ),
    );
  }

  Widget _surface({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(18),
    double radius = 16,
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }

  TextStyle _text({
    required double size,
    FontWeight weight = FontWeight.w400,
    Color color = const Color(0xFF1F2937),
  }) {
    return TextStyle(
      fontSize: size,
      height: 1.25,
      fontWeight: weight,
      color: color,
      letterSpacing: -0.25,
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.period,
    required this.subject,
    required this.time,
    required this.next,
    required this.room,
  });

  final String period;
  final String subject;
  final String time;
  final String next;
  final String room;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 15, 18, 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  period,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: GoneColors.primary,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(width: 19),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '2학년 2반',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF667085),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFD6DAE1)),
          const SizedBox(height: 9),
          Row(
            children: [
              Text(
                '다음',
                style: TextStyle(fontSize: 10, color: Color(0xFF667085)),
              ),
              SizedBox(width: 11),
              Text(
                next,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              ),
              Spacer(),
              Text(
                room,
                style: TextStyle(fontSize: 10, color: Color(0xFF667085)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  const _MealCard({
    required this.meal,
    required this.time,
    required this.leftMenu,
    required this.rightMenu,
    required this.calorie,
  });

  final String meal;
  final String time;
  final String leftMenu;
  final String rightMenu;
  final String calorie;

  @override
  Widget build(BuildContext context) {
    const text = TextStyle(fontSize: 12, height: 1.85, letterSpacing: -0.2);
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '오늘의 급식',
                style: TextStyle(fontSize: 10, color: Color(0xFF98A2B3)),
              ),
              Spacer(),
              Text(
                time,
                style: TextStyle(fontSize: 10, color: Color(0xFF667085)),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            meal,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(leftMenu, style: text)),
              Expanded(child: Text(rightMenu, style: text)),
            ],
          ),
          SizedBox(height: 9),
          Text(
            calorie,
            style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
          ),
        ],
      ),
    );
  }
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontSize: 10, color: Color(0xFF667085)),
      ),
      const SizedBox(height: 4),
      Text(
        value,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    ],
  );
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.text,
    required this.background,
    required this.foreground,
  });

  final String text;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
    ),
  );
}

class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.image,
    required this.title,
    required this.detail,
    required this.status,
    required this.statusColor,
  });

  final String image;
  final String title;
  final String detail;
  final String status;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 35, height: 35, fit: BoxFit.contain),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF667085),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 20, color: Color(0xFF344054)),
        ],
      ),
    );
  }
}
