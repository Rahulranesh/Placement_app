import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  CustomBottomNavBar(
      {required this.currentIndex, required this.onTap, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, offset: Offset(4, 4), blurRadius: 10),
          BoxShadow(
              color: Colors.white, offset: Offset(-4, -4), blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blueGrey,
          unselectedItemColor: Colors.grey,
          elevation: 0,
        ),
      ),
    );
  }
}
