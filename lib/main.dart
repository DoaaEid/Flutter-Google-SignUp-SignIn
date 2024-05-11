import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pillars/View/Authentication/sign-up-normal-user.dart';
import 'package:pillars/View/Authentication/sign_in_page.dart';
import 'package:pillars/View/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     // home: AccountCreationPage(), // Use CeramicShopApp here
      home: Login(),
    );
  }
}
