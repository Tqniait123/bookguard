import 'package:flutter/material.dart';

class LineWidget extends StatelessWidget {
  const LineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF8696BB).withValues(alpha: 0.15),
            Color(0xFF8696BB).withValues(alpha: 0.95),
            Color(0xFF8696BB).withValues(alpha: 0.15),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
