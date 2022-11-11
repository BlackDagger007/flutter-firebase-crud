import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_tut/pages/add_user_page.dart';

import '../models/user.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  Stream<List<User>> _readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: StreamBuilder<List<User>>(
        stream: _readUsers(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddUserPage(),
            ));
          },
          child: const Icon(Icons.add)),
    );
  }

  Widget buildUser(User user) {
    return ListTile(
        leading: CircleAvatar(child: Text(user.age.toString())),
        title: Text(user.name),
        trailing: Text(user.birthday.toIso8601String()));
  }
}
