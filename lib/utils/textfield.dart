import 'package:flutter/material.dart';
import 'package:place/utils/container.dart';

class neumorphicTextField extends StatelessWidget {
  final String label;
  final Function(String) onSaved;
  final bool obscureText;

  neumorphicTextField({
    required this.label,
    required this.onSaved,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: BorderRadius.circular(10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
        ),
        obscureText: obscureText,
        onSaved: (value) => onSaved(value!),
        validator: (value) => value!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }
}
