import 'package:flutter/material.dart';
import 'package:place/admin/admin_upload_qnpeprs_screen.dart';
import 'package:place/screen/campus_map.dart';

import 'admin_upload_staff_screen.dart';
import 'admin_upload_exams_screen.dart';
import 'admin_upload_placement_screen.dart';

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
    'Campus Map',
  ];

  // Each tab shows a list of existing uploads and has an Add button.
  final List<Widget> _widgetOptions = [
    AdminUploadStaffScreen(),
    AdminUploadExamsScreen(),
    AdminUploadQNPapersScreen(),
    AdminUploadPlacementScreen(),
    CampusMap(), // Campus map shared.
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Determine the current “upload” action.
  void _onAddPressed() {
    // For tabs 0 to 3, we allow adding new content.
    // For Campus Map, no add action is needed.
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _widgetOptions[_selectedIndex],
      floatingActionButton: _selectedIndex < 4
          ? FloatingActionButton(
              onPressed: _onAddPressed,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Staffs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Exams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Q/N Papers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Placement Mat.',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Campus Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
