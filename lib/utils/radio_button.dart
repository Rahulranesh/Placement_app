import 'package:flutter/material.dart';

class NeumorphicRadio<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String label;

  NeumorphicRadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    bool selected = value == groupValue;
    Color baseColor = Colors.grey[300]!;
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
                  // For selected state, use a shallower shadow for a pressed look.
                  BoxShadow(
                    color: Colors.grey[500]!,
                    offset: Offset(2, 2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(-2, -2),
                    blurRadius: 5,
                    spreadRadius: 1,
                  ),
                ]
              : [
                  // For unselected state, use deeper shadows.
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
        padding: EdgeInsets.all(8.0),
        child: Text(label, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
