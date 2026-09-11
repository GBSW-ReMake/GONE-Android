import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gone/core/app_widgets.dart';
import 'package:gone/features/home/presentation/widgets/meal_card.dart';
import 'package:gone/features/home/presentation/widgets/profile_card.dart';
import 'package:gone/features/home/presentation/widgets/schedule_card.dart';

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
      ScheduleCard(),
      MealCard(),
    ],
  );

  // Widget _home(int unreadCount) {
  //   return ListView(
  //     padding: const EdgeInsets.fromLTRB(26, 24, 26, 20),
  //     children: [
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
