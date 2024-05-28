import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pillars/View/admin/add_user.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data() as Map<String, dynamic>;

              final name = data.containsKey('name') ? data['name'] : 'No Name';
              final userType = data.containsKey('userType') ? data['userType'] : 'No User Type';
              final email = data.containsKey('email') ? data['email'] : 'No Email';

              return UserTile(
                userId: user.id,
                name: name,
                userType: userType,
                email: email,
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddUserPage()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,



      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final String userId;
  final String name;
  final String userType;
  final String email;

  UserTile({required this.userId, required this.name, required this.userType, required this.email});

  void _showUserDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('User Type: $userType'),
              SizedBox(height: 8.0),
              Text('Email: $email'),
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
    final _nameController = TextEditingController(text: name);
    final _userTypeController = TextEditingController(text: userType);
    final _emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _userTypeController,
                decoration: InputDecoration(labelText: 'User Type'),
              ),
              TextField(
                controller: _emailController,
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
                FirebaseFirestore.instance.collection('users').doc(userId).update({
                  'name': _nameController.text,
                  'userType': _userTypeController.text,
                  'email': _emailController.text,
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
    FirebaseFirestore.instance.collection('users').doc(userId).delete();
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
                name,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5.0),
              Text(
                userType,
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
