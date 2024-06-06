import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pillars/View/Employee/task_details_page.dart';

class EmployeeTasksPage extends StatefulWidget {
  @override
  _EmployeeTasksPageState createState() => _EmployeeTasksPageState();
}

class _EmployeeTasksPageState extends State<EmployeeTasksPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    _user = _auth.currentUser;

    if (_user != null) {
      final userDoc = await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userName = userDoc['name'];
        });
      }
    }
  }

  Future<void> _updateTask(String taskId, bool isCompleted) async {
    await _firestore.collection('tasks').doc(taskId).update({
      'isCompleted': isCompleted,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
      ),
      body: _userName == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('tasks')
            .where('employee', isEqualTo: _userName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!.docs;

          if (tasks.isEmpty) {
            return Center(child: Text('No tasks assigned to you.'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              bool isCompleted = task['isCompleted'] ?? false;
              return Card(
                margin: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(task['title']),
                  subtitle: Text(task['description']),
                  trailing: Checkbox(
                    value: isCompleted,
                    onChanged: (newValue) {
                      _updateTask(task.id, newValue!);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TaskDetailsPage(task: task),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
