import 'package:flutter/material.dart';

class EmployeePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Page"),
      ),
      body: Center(
        child: Text(
          "Welcome, Employee!",
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
