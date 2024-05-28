import 'package:flutter/material.dart';
import 'dart:async';

import 'package:pillars/View/Authentication/sign_in_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double _opacity = 1.0;
  Timer? _timer;
  bool _isVisible = true;

  @override
  void initState() {
    super.initState();

    // Create a timer that toggles the opacity every 500 milliseconds
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      setState(() {
        _isVisible = !_isVisible;
        _opacity = _isVisible ? 1.0 : 0.0;
      });
    });

    // Navigate to the next page after 3 seconds
    Future.delayed(Duration(seconds: 5), () {
      _timer?.cancel(); // Cancel the timer
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedOpacity(
              opacity: _opacity,
              duration: Duration(milliseconds: 500),
              child: Image.asset(
                'assets/logo.png', // Path to your logo
                width: 250, // Increased width
                height: 250, // Increased height
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to Pillars!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}