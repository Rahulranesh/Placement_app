import 'package:flutter/material.dart';

class neumorphicButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;

  neumorphicButton({
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color baseColor = Colors.grey[300]!;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[500]!,
              offset: Offset(4, 4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.white,
              offset: Offset(-4, -4),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: child,
      ),
    );
  }
}

/// A custom neumorphi