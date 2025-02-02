// custom_app_bar.dart
import 'package:flutter/material.dart';
import 'package:place/screen/chat_screen.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.chat),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => ChatScreen()));
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
