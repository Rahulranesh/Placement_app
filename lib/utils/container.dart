import 'package:flutter/material.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  NeumorphicContainer({
    required this.child,
    this.borderRadius,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    Color baseColor = color ?? Colors.grey[300]!;
    return Container(
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: borderRadius,
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
      padding: padding,
      child: child,
    );
  }
}
