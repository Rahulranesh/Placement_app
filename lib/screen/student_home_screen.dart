import 'package:flutter/material.dart';
import 'staffs_screen.dart';
import 'exams_screen.dart';
import 'qnpapers_screen.dart';
import 'placement_preparation_screen.dart';
import 'campus_map.dart';

class StudentHomeScreen extends StatefulWidget {
  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;

  static  List<Widget> _widgetOptions = <Widget>[
    StaffsScreen(),
    ExamsScreen(),
    QNPapersScreen(),
    PlacementPreparationScreen(),
    CampusMap(), // Shared campus map.
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Placement App')),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
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
            label: 'Placement Prep',
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
