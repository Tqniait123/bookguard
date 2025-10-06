import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class GradientCircleAvatar extends StatelessWidget {
  final Widget child;
  final double size;
  final double borderWidth;

  const GradientCircleAvatar({
    Key? key,
    required this.child,
    this.size = 150,
    this.borderWidth = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const SweepGradient(
          colors: [
            Color(0xFF000000),
            Color(0xFFE8F34E), // Yellow-green
            Color(0xFFFFA500), // Orange
            Color(0xFFFF4500), // Red-orange
            Color(0xFFE8F34E), // Yellow-green (complete circle)
          ],
          stops: [0.0, 0.33, 0.66, 1.0, 0.1],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(borderWidth),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: child,
          ),
        ),
      ),
    );
  }
}
