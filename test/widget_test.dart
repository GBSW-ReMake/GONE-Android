import 'package:flutter_test/flutter_test.dart';
import 'package:gone/app/gone_app.dart';

void main() {
  testWidgets('스플래시 이후 역할 선택 화면을 표시한다', (tester) async {
    await tester.pumpWidget(const GoneApp());
    await tester.pump(const Duration(milliseconds: 550));
    await tester.pumpAndSettle();

    expect(find.text('학생으로 로그인'), findsOneWidget);
    expect(find.text('선생님으로 로그인'), findsOneWidget);
  });
}
