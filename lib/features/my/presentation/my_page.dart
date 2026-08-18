import 'package:flutter/material.dart';

import '../../../core/design_system/gone_theme.dart';
import '../domain/my_activity.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key, required this.onLogout});

  final VoidCallback onLogout;

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  MyActivityFilter _filter = MyActivityFilter.all;

  List<MyActivity> get _activities => myActivities
      .where(
        (activity) => switch (_filter) {
          MyActivityFilter.all => true,
          MyActivityFilter.lab => activity.type == MyActivityType.lab,
          MyActivityFilter.outing => activity.type == MyActivityType.outing,
          MyActivityFilter.camping => activity.type == MyActivityType.camping,
        },
      )
      .toList();

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF3F5F9),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(26, 22, 26, 28),
        children: [
          const Text(
            '마이',
            style: TextStyle(fontSize: 13, color: Color(0xFF667085)),
          ),
          const SizedBox(height: 5),
          const Text(
            '계정 및 활동',
            style: TextStyle(
              fontSize: 25,
              height: 1.15,
              letterSpacing: -0.8,
              fontWeight: FontWeight.w700,
              color: GoneColors.deepNavy,
            ),
          ),
          const SizedBox(height: 28),
          const _AccountCard(),
          const SizedBox(height: 24),
          _MenuCard(
            icon: Icons.notifications_none_rounded,
            title: '알림 설정',
            onTap: () => _showNotice('알림 설정은 준비 중입니다.'),
          ),
          const SizedBox(height: 10),
          _MenuCard(
            icon: Icons.question_answer_outlined,
            title: '문의하기',
            onTap: () => _showNotice('문의하기는 준비 중입니다.'),
          ),
          const SizedBox(height: 30),
          const Text(
            '최근 활동',
            style: TextStyle(
              fontSize: 22,
              letterSpacing: -0.6,
              fontWeight: FontWeight.w700,
              color: GoneColors.deepNavy,
            ),
          ),
          const SizedBox(height: 16),
          _ActivityFilterBar(
            selected: _filter,
            onSelected: (filter) => setState(() => _filter = filter),
          ),
          const SizedBox(height: 16),
          for (final activity in _activities) ...[
            _ActivityCard(activity: activity),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: _confirmLogout,
              style: TextButton.styleFrom(
                foregroundColor: GoneColors.error,
                minimumSize: const Size(110, 42),
              ),
              child: const Text(
                '로그아웃',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  void _showNotice(String message) => ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(message)));

  Future<void> _confirmLogout() async {
    final logout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('로그아웃하면 역할 선택 화면으로 이동합니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: GoneColors.error),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );
    if (logout == true && mounted) widget.onLogout();
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(21),
    ),
    child: Row(
      children: [
        Container(
          width: 60,
          height: 60,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: GoneColors.deepNavy,
            shape: BoxShape.circle,
          ),
          child: const Text(
            '김',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 17),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '김은찬',
                style: TextStyle(
                  fontSize: 21,
                  letterSpacing: -0.6,
                  fontWeight: FontWeight.w700,
                  color: GoneColors.deepNavy,
                ),
              ),
              SizedBox(height: 3),
              Text(
                '소프트웨어개발과 · 2학년 2반 · 6번',
                style: TextStyle(fontSize: 12, color: Color(0xFF667085)),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: title,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        height: 82,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: const Color(0xFF667085)),
            const SizedBox(width: 19),
            Text(
              title,
              style: const TextStyle(
                fontSize: 19,
                letterSpacing: -0.5,
                fontWeight: FontWeight.w700,
                color: GoneColors.deepNavy,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              size: 28,
              color: Color(0xFF667085),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ActivityFilterBar extends StatelessWidget {
  const _ActivityFilterBar({required this.selected, required this.onSelected});
  final MyActivityFilter selected;
  final ValueChanged<MyActivityFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    const filters = [
      (MyActivityFilter.all, '전체'),
      (MyActivityFilter.lab, '실습실'),
      (MyActivityFilter.outing, '외출'),
      (MyActivityFilter.camping, '스쿨캠핑'),
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((item) {
          final isSelected = selected == item.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 9),
            child: Semantics(
              button: true,
              selected: isSelected,
              label: '${item.$2} 활동 필터',
              child: InkWell(
                onTap: () => onSelected(item.$1),
                borderRadius: BorderRadius.circular(15),
                child: Ink(
                  height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  decoration: BoxDecoration(
                    color: isSelected ? GoneColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: isSelected
                        ? null
                        : Border.all(
                            color: const Color(0xFFD6DAE1),
                            width: 1.2,
                          ),
                  ),
                  child: Center(
                    child: Text(
                      item.$2,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF667085),
                      ),
                    ),
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

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.activity});
  final MyActivity activity;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: '${activity.title} 활동 보기',
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        height: 114,
        padding: const EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset(
              activity.image,
              width: 44,
              height: 44,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.category,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF667085),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 18,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w700,
                      color: GoneColors.deepNavy,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.detail,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF667085),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 27,
              color: Color(0xFF98A2B3),
            ),
          ],
        ),
      ),
    ),
  );
}
