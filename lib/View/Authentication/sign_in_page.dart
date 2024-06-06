import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pillars/View/Authentication/forget_password.dart';
import 'package:pillars/View/Authentication/sign-up-normal-user.dart';
import 'package:pillars/View/Employee/employee_page.dart';
import 'package:pillars/View/Employee/list_task_employee.dart';
import 'package:pillars/View/Welcome/WelcomePage.dart';
import 'package:pillars/View/admin/add_task.dart';
import 'package:pillars/View/admin/add_user.dart';
import 'package:pillars/View/admin/admin_page.dart';
import 'package:pillars/View/home_page.dart';  // Assume this is the normal user home page

class Login extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        _navigateToUserHome(userCredential.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Login failed!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _navigateToUserHome(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        String userType = userDoc['userType'];

        if (userType == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        } else if (userType == 'Employee') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePageEmployee()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get user type: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(25.0),
              ),
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Image.asset('assets/logo.png', height: 150),
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                    obscureText: true,
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _login,
                    child: Text("Log in"),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueGrey),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountCreationPage()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'You do not have account? ',
                        style: TextStyle(color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Create account !',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  RichText(
                    text: TextSpan(
                      text: 'OR',
                      style: TextStyle(color: Colors.black),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebook, size: 40.0),
                        color: Colors.blue,
                        onPressed: () {
                          // Add your Facebook login logic here
                        },
                      ),
                      SizedBox(width: 10.0),
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.google, size: 40.0),
                        color: Colors.red,
                        onPressed: () {
                          // Add your Google login logic here
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
