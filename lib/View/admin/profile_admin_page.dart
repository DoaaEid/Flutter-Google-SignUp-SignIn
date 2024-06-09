import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  String name = '';
  String email = '';
  String userType = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user!.uid).get();
      setState(() {
        name = userDoc['name'];
        email = userDoc['email'];
        userType = userDoc['userType'];
        isLoading = false;
      });
    }
  }

  _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _firestore.collection('users').doc(user!.uid).update({
        'name': name,
        'email': email,
      });
      await user!.updateEmail(email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Placeholder image
              ),
              SizedBox(height: 20),
              Text(
                'Welcome, $name!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSaved: (value) => name = value!,
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSaved: (value) => email = value!,
                validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                initialValue: userType,
                decoration: InputDecoration(
                  labelText: 'User Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _updateUserData,
                child: Text('Update Profile'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
