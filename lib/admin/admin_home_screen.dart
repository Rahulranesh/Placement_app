import 'package:flutter/material.dart';
import 'package:place/admin/admin_upload_staff_screen.dart';
import 'package:place/admin/admin_upload_exams_screen.dart';
import 'package:place/admin/admin_upload_qnpeprs_screen.dart';
import 'package:place/admin/admin_upload_placement_screen.dart';
import 'package:place/admin/admin_upload_placement_info_screen.dart';
import 'package:place/route_transition.dart';
import 'package:place/utils/custom_appbar.dart';
import 'package:place/utils/custom_bottom_nav_bar.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/services/auth_services.dart';
import 'package:place/screen/login_screen.dart';


class AdminHomeScreen extends StatefulWidget {
  final ValueNotifier<bool> themeNotifier;
  const AdminHomeScreen({Key? key, required this.themeNotifier})
      : super(key: key);

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
    // When in "uploadOnly" mode, navigate with a fade transition.
    if (_selectedIndex == 0) {
      Navigator.push(context,
          createRoute(AdminUploadStaffScreen(uploadOnly: true)));
    } else if (_selectedIndex == 1) {
      Navigator.push(context,
          createRoute(AdminUploadExamsScreen(uploadOnly: true)));
    } else if (_selectedIndex == 2) {
      Navigator.push(context,
          createRoute(AdminUploadQNPapersScreen(uploadOnly: true)));
    } else if (_selectedIndex == 3) {
      Navigator.push(context,
          createRoute(AdminUploadPlacementScreen(uploadOnly: true)));
    } else if (_selectedIndex == 4) {
      Navigator.push(context,
          createRoute(AdminUploadPlacementInfoScreen(uploadOnly: true)));
    }
  }

  Future<void> _logout() async {
    await AuthService().logout();
    Navigator.pushReplacement(context, createRoute(LoginScreen(themeNotifier: widget.themeNotifier)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: _titles[_selectedIndex], showNotificationButton: true),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20)),
              ),
              child: Center(
                  child: Text('Admin Panel',
                      style: TextStyle(color: Colors.white, fontSize: 24))),
            ),
            ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text('Dark Mode'),
              trailing: Switch(
                value: widget.themeNotifier.value,
                onChanged: (val) {
                  widget.themeNotifier.value = val;
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: NeumorphicContainer(
          padding: EdgeInsets.all(16),
          child: _widgetOptions[_selectedIndex],
        ),
      ),
      floatingActionButton: _selectedIndex < _widgetOptions.length
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
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Placement Mat.'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Placement Info'),
        ],
      ),
    );
  }
}
