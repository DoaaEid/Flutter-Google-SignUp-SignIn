import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskDetailsPage extends StatelessWidget {
  final DocumentSnapshot task;

  TaskDetailsPage({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              task['title'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text(
              'Description:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              task['description'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Completed:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                task['isCompleted']
                    ? Icon(Icons.check, color: Colors.green)
                    : Icon(Icons.close, color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
