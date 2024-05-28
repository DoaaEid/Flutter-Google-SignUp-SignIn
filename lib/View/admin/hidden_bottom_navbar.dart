import 'package:flutter/material.dart';


class HiddenBottomNavBar extends StatefulWidget {

  @override
  _HiddenBottomNavBarState createState() => _HiddenBottomNavBarState();
}

class _HiddenBottomNavBarState extends State<HiddenBottomNavBar> with SingleTickerProviderStateMixin {
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
        title: Text('Hidden Bottom Navigation Bar'),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.primaryDelta! < -20) {
            _showNavBar();
          }
        },
        child: Center(
          child: Text('Swipe right to show Bottom Navigation b'),
        ),
      ),
      bottomNavigationBar: SlideTransition(
        position: _animation,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          color: Colors.blue,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.person),
                color: Colors.white,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.assignment),
                color: Colors.white,
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.person_add),
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNavBar() {
    if (!_isNavBarVisible) {
      _animationController.forward();
      _isNavBarVisible = true;
    }
  }
}