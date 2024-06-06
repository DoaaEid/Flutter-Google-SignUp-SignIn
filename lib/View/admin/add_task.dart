import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTaskPage extends StatefulWidget {
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedEmployee;
  List<String> _employeeNames = [];
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeNames();
  }

  Future<void> _fetchEmployeeNames() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('userType', isEqualTo: 'Employee')
        .get();

    setState(() {
      _employeeNames = querySnapshot.docs.map((doc) => doc['name'].toString()).toList();
    });
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate() && _selectedEmployee != null) {
      await FirebaseFirestore.instance.collection('tasks').add({
        'title': _titleController.text,
        'employee': _selectedEmployee,
        'description': _descriptionController.text,
        'isCompleted': _isCompleted,
        'created_at': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Task added successfully!'),
        backgroundColor: Colors.green,
      ));

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all fields!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Task')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Task Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: _selectedEmployee,
                  items: _employeeNames.map((String employee) {
                    return DropdownMenuItem<String>(
                      value: employee,
                      child: Text(employee),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedEmployee = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Select Employee'),
                  validator: (value) => value == null ? 'Please select an employee' : null,
                ),
                SizedBox(height: 25.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Task Description',
                      contentPadding: EdgeInsets.all(25.0),
                      border: InputBorder.none,
                    ),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a task description';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                CheckboxListTile(
                  title: Text('Is Completed'),
                  value: _isCompleted,
                  onChanged: (newValue) {
                    setState(() {
                      _isCompleted = newValue!;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addTask,
                    child: Text('Add Task', style: TextStyle(fontSize: 15.0)),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      backgroundColor: Colors.blueGrey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
