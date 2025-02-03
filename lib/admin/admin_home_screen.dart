import 'package:flutter/material.dart';
import 'package:place/admin/admin_upload_exams_screen.dart';
import 'package:place/admin/admin_upload_placement_info_screen.dart';
import 'package:place/admin/admin_upload_placement_screen.dart';
import 'package:place/admin/admin_upload_qnpeprs_screen.dart';
import 'package:place/admin/admin_upload_staff_screen.dart';
import 'package:place/screen/campus_map.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:place/utils/custom_bottom_nav_bar.dart';
import 'package:place/utils/neumorphic_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;
  static const List<String> _titles = <String>[
    'Manage Staffs',
    'Manage Exams',
    'Manage Q/N Papers',
    'Manage Placement Materials',
    'Manage Placement Info',
    'Campus Map',
  ];
  final List<Widget> _widgetOptions = [
    AdminUploadStaffScreen(),
    AdminUploadExamsScreen(),
    AdminUploadQNPapersScreen(),
    AdminUploadPlacementScreen(),
    AdminUploadPlacementInfoScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onAddPressed() {
    if (_selectedIndex == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminUploadStaffScreen(uploadOnly: true)));
    } else if (_selectedIndex == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminUploadExamsScreen(uploadOnly: true)));
    } else if (_selectedIndex == 2) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AdminUploadQNPapersScreen(uploadOnly: true)));
    } else if (_selectedIndex == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AdminUploadPlacementScreen(uploadOnly: true)));
    } else if (_selectedIndex == 4) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AdminUploadPlacementInfoScreen(uploadOnly: true)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pass showNotificationButton: true for admin screens.
      appBar: CustomAppBar(title: _titles[_selectedIndex], showNotificationButton: true),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: NeumorphicContainer(
          padding: EdgeInsets.all(16),
          child: _widgetOptions[_selectedIndex],
        ),
      ),
      floatingActionButton: _selectedIndex < 5
          ? FloatingActionButton(
              onPressed: _onAddPressed,
              child: Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Staffs'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Exams'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Q/N Papers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'Placement Mat.'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'Placement Info'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Campus Map'),
        ],
      ),
    );
  }
}
