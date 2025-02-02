import 'package:flutter/material.dart';
import 'staffs_screen.dart';
import 'exams_screen.dart';
import 'qnpapers_screen.dart';
import 'placement_preparation_screen.dart';
import 'campus_map.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'login_screen.dart';
import 'package:place/services/auth_services.dart';

class StudentHomeScreen extends StatefulWidget {
  final ValueNotifier<bool>? themeNotifier;
  StudentHomeScreen({Key? key, this.themeNotifier}) : super(key: key);

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    StaffsScreen(),
    ExamsScreen(),
    QNPapersScreen(),
    PlacementPreparationScreen(),
    CampusMap(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    await AuthService().logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(themeNotifier: widget.themeNotifier),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Placement App'),
      ),
      // Drawer added to student home screen.
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Welcome!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.show_chart),
              title: Text('Track Progress'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProgressScreen()),
                );
              },
            ),
            SwitchListTile(
              secondary: Icon(Icons.brightness_6),
              title: Text('Dark Mode'),
              value: widget.themeNotifier?.value ?? false,
              onChanged: (value) {
                if (widget.themeNotifier != null) {
                  widget.themeNotifier!.value = value;
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Staffs'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Exams'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Q/N Papers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.school), label: 'Placement Prep'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Campus Map'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
