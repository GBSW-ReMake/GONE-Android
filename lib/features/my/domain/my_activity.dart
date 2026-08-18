enum MyActivityFilter { all, lab, outing, camping }

enum MyActivityType { lab, outing, camping }

class MyActivity {
  const MyActivity({
    required this.type,
    required this.category,
    required this.title,
    required this.detail,
    required this.image,
  });

  final MyActivityType type;
  final String category;
  final String title;
  final String detail;
  final String image;
}

const myActivities = [
  MyActivity(type: MyActivityType.lab, category: '실습실 예약', title: 'iOS실 예약', detail: '7월 30일 목요일 · 19:10 ~ 20:30', image: 'assets/images/home-lab.png'),
  MyActivity(type: MyActivityType.outing, category: '외출 신청', title: '외출 신청', detail: '8월 8일 · 병원 방문', image: 'assets/images/home-outing.png'),
  MyActivity(type: MyActivityType.camping, category: '스쿨캠핑 예약', title: '스쿨캠핑 예약', detail: '8월 22일 금요일 · 4명', image: 'assets/images/home-camping.png'),
];
