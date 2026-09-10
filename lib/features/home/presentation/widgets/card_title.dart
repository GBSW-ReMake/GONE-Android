import 'package:flutter/material.dart';
import 'package:gone/core/design_system/gone_theme.dart';

class CardTitle extends StatelessWidget {
  const CardTitle({
    super.key,
    required this.icon,
    required this.label,
    this.action,
  });

  final String icon;
  final String label;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        spacing: 6,
        children: [
          Image.asset('assets/images/$icon', width: 22),
          Text(label, style: TextTheme.of(context).titleMedium?.copyWith(
            color: GoneColors.textPrimary,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),),
          ?action,
        ],
      ),
    );
  }
}
