import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gone/features/my/presentation/my_page.dart';

void main() {
  testWidgets('활동 필터는 선택한 유형의 활동만 표시한다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: MyPage(onLogout: _empty)));

    expect(find.text('iOS실 예약'), findsOneWidget);
    expect(find.text('스쿨캠핑 예약'), findsNWidgets(2));

    await tester.tap(find.text('외출'));
    await tester.pump();

    expect(find.text('iOS실 예약'), findsNothing);
    expect(find.text('외출 신청'), findsNWidgets(2));
    expect(find.text('스쿨캠핑 예약'), findsNothing);
  });

  testWidgets('로그아웃 확인 후 전달된 로그아웃 동작을 실행한다', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var loggedOut = false;
    await tester.pumpWidget(
      MaterialApp(home: MyPage(onLogout: () => loggedOut = true)),
    );

    await tester.tap(find.text('로그아웃'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('로그아웃').last);
    await tester.pumpAndSettle();

    expect(loggedOut, isTrue);
  });
}

void _empty() {}
