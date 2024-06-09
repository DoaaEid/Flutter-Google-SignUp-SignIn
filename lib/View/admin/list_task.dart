import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pillars/View/admin/add_task.dart';

class TaskListPage extends StatefulWidget {
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No task found'));
          }

          final tasks = snapshot.data!.docs;

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final data = task.data() as Map<String, dynamic>;

              final title = data.containsKey('title') ? data['title'] : 'No title';
              final employee = data.containsKey('employee') ? data['employee'] : 'No employee';
              final description = data.containsKey('description') ? data['description'] : 'No description';
            //  final isCompleted = data.containsKey('isCompleted') ? data['isCompleted'] : 'No isCompleted';


              return UserTile(
                  taskid: task.id,
                  title: title,
                  employee: employee,
                  description: description,
                 // isCompleted:isCompleted
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,



      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String taskid;
  final String title;
  final String employee;
  final String description;

  UserTile({required this.taskid, required this.title, required this.employee, required this.description});

  void _showUserDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('employee: $employee'),
              SizedBox(height: 8.0),
              Text('description: $description'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: Colors.blueGrey)),

            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showEditUserDialog(context);
              },
              child: Text('Edit', style: TextStyle(color: Colors.blueGrey,)),

            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context) {
    final _titleController = TextEditingController(text: title);
    final _employeeController = TextEditingController(text: employee);
    final _descriptionController = TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _employeeController,
                decoration: InputDecoration(labelText: 'User Type'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.blueGrey),),
            ),
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('tasks').doc(taskid).update({
                  'title': _titleController.text,
                  'employee': _employeeController.text,
                  'description': _descriptionController.text,
                });
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.blueGrey),),
            ),
          ],
        );
      },
    );
  }

  void _deleteUser(BuildContext context) {
    FirebaseFirestore.instance.collection('tasks').doc(taskid).delete();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUserDetails(context),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              Text(
                employee,
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
