import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/design_system/gone_theme.dart';

class GonePrimaryButton extends StatelessWidget {
  const GonePrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: GoneColors.primary,
          disabledBackgroundColor: Theme.of(
            context,
          ).colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}

class GoneBackButton extends StatelessWidget {
  const GoneBackButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      button: true,
      child: IconButton(
        tooltip: label,
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_ios_new_rounded),
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
      ),
    );
  }
}

class GoneLogo extends StatelessWidget {
  const GoneLogo({super.key, this.width = 100});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'GONE',
      image: true,
      child: SvgPicture.asset(
        'assets/images/gone-logo.svg',
        width: width,
        height: width * 0.28,
      ),
    );
  }
}

void showServiceNotice(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(content: Text(message)));
}
