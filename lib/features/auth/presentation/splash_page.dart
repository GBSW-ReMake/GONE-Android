import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/app_widgets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      if (MediaQuery.disableAnimationsOf(context)) {
        await _controller.animateTo(
          1,
          duration: const Duration(milliseconds: 240),
        );
      } else {
        await _controller.forward();
      }
      if (mounted) widget.onFinished();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transition = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: Tween<double>(begin: 1, end: 0).animate(transition),
          child: ScaleTransition(
            scale: Tween<double>(begin: 1, end: 0.64).animate(transition),
            child: const GoneLogo(width: 235),
          ),
        ),
      ),
    );
  }
}
