import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pillars/View/Authentication/sign-up-normal-user.dart';
import 'package:pillars/View/Authentication/sign_in_page.dart';
import 'package:pillars/View/Employee/completed_tasks.dart';
import 'package:pillars/View/Employee/list_task_employee.dart';
import 'package:pillars/View/Welcome/WelcomePage.dart';
import 'package:pillars/View/admin/add_task.dart';
import 'package:pillars/View/admin/add_user.dart';
import 'package:pillars/View/admin/list_all_user.dart';
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
      home: WelcomePage(),
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
     //   '/your-tasks': (context) => YourTasksPage(),
        '/completed-tasks': (context) => CompletedTasksPage(),
        '/your-tasks': (context) => EmployeeTasksPage(),
      },
     // home: AddTaskPage(),
    );
  }
}
