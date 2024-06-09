import 'package:flutter/material.dart';
import 'package:pillars/View/admin/list_all_user.dart';
import 'package:pillars/View/admin/list_task.dart';
import 'package:pillars/View/admin/profile_admin_page.dart';

class HiddenSideNavBar extends StatefulWidget {
  @override
  _HiddenSideNavBarState createState() => _HiddenSideNavBarState();
}

class _HiddenSideNavBarState extends State<HiddenSideNavBar> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isNavBarVisible = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
      ),
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_isNavBarVisible) {
                _hideNavBar();
              }
            },
            onHorizontalDragUpdate: (details) {
              if (details.primaryDelta! > 20 && !_isNavBarVisible) {
                _showNavBar();
              }
            },
            child: UserListPage(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SlideTransition(
              position: _animation,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildNavItem(
                      icon: Icons.person,
                      label: 'Profile',
                      onTap: () => _navigateToPage(context, ProfilePage()),
                      fontSize: 16,
                    ),
                    _buildNavItem(
                      icon: Icons.assignment,
                      label: 'List Tasks',
                      onTap: () => _navigateToPage(context, TaskListPage()),
                      fontSize: 16,
                    ),
                    _buildNavItem(
                      icon: Icons.person_add,
                      label: 'List User',
                      onTap: () => _navigateToPage(context, UserListPage()),
                      fontSize: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required VoidCallback onTap, required double fontSize}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: TextStyle(color: Colors.white, fontSize: fontSize)),
      onTap: onTap,
    );
  }

  void _showNavBar() {
    _animationController.forward();
    setState(() {
      _isNavBarVisible = true;
    });
  }

  void _hideNavBar() {
    _animationController.reverse();
    setState(() {
      _isNavBarVisible = false;
    });
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}


