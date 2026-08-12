import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/design_system/gone_theme.dart';
import '../features/auth/presentation/auth_flow_page.dart';

class GoneApp extends StatelessWidget {
  const GoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'GONE',
        debugShowCheckedModeBanner: false,
        theme: GoneTheme.light(),
        darkTheme: GoneTheme.dark(),
        themeMode: ThemeMode.system,
        home: const AuthFlowPage(),
      ),
    );
  }
}
