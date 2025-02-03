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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color baseColor = color ?? Theme.of(context).scaffoldBackgroundColor;
    return Container(
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(4, 4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black87,
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(4, 4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class NeumorphicTextField extends StatelessWidget {
  final String label;
  final Function(String) onSaved;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  NeumorphicTextField({
    required this.label,
    required this.onSaved,
    this.obscureText = false,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: BorderRadius.circular(10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: label,
          border: InputBorder.none,
        ),
        obscureText: obscureText,
        onSaved: (value) => onSaved(value!),
        validator: validator ?? (value) => value!.isEmpty ? 'Enter $label' : null,
      ),
    );
  }
}

Widget neumorphicButton({required VoidCallback onPressed, required Widget child}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      shadowColor: Colors.black12,
    ),
    onPressed: onPressed,
    child: child,
  );
}

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
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    Color baseColor = Theme.of(context).scaffoldBackgroundColor;
    return GestureDetector(
      onTap: () {
        onChanged(value);
      },
      child: Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? (isDark
                  ? [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          spreadRadius: 1),
                      BoxShadow(
                          color: Colors.black87,
                          offset: Offset(-2, -2),
                          blurRadius: 5,
                          spreadRadius: 1),
                    ]
                  : [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(2, 2),
                          blurRadius: 5,
                          spreadRadius: 1),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(-2, -2),
                          blurRadius: 5,
                          spreadRadius: 1),
                    ])
              : (isDark
                  ? [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1),
                      BoxShadow(
                          color: Colors.black87,
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1),
                    ]
                  : [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(4, 4),
                          blurRadius: 10,
                          spreadRadius: 1),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 10,
                          spreadRadius: 1),
                    ]),
        ),
        padding: EdgeInsets.all(8.0),
        child: Text(label, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
