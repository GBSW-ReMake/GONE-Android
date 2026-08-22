import 'package:flutter/material.dart';

import '../../../core/design_system/gone_theme.dart';

/// 교사의 상벌점 발급 기능 진입 화면입니다.
class PointSystemPage extends StatelessWidget {
  const PointSystemPage({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: Color(0xFFF3F5F9),
    body: SafeArea(
      child: Center(
        child: Text(
          '상벌점 기능을 준비하고 있습니다.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: GoneColors.deepNavy,
          ),
        ),
      ),
    ),
  );
}
