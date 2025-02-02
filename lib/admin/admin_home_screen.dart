import 'package:flutter/material.dart';
import 'package:place/admin/admin_upload_placement_info_screen.dart';
import 'package:place/admin/admin_upload_qnpeprs_screen.dart'; // Verify the filename and class name!
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

  // Ensure there are exactly 6 titles (one for each tab).
  static const List<String> _titles = <String>[
    'Manage Staffs',
    'Manage Exams',
    'Manage Q/N Papers',
    'Manage Placement Materials',
    'Manage Placement Info',
    'Campus Map',
  ];

  // Ensure these widgets are defined in the imported files and have callable constructors.
  final List<Widget> _widgetOptions = [
    AdminUploadStaffScreen(),
    AdminUploadExamsScreen(),
    AdminUploadQNPapersScreen(),
    AdminUploadPlacementScreen(),
    AdminUploadPlacementInfoScreen(),
    CampusMap(),
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
              builder: (context) => AdminUploadPlacementInfoScreen(
                    uploadOnly: true,
                  )));
    }
    // No upload action for Campus Map (index 5)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _widgetOptions[_selectedIndex],
      ),
      // FloatingActionButton is shown for indices 0-4 (uploadable screens)
      floatingActionButton: _selectedIndex < 5
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
            icon: Icon(Icons.school),
            label: 'Placement info.',
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
