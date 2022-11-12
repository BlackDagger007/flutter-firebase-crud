import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_tut/pages/add_user_page.dart';
import 'package:flutter_firebase_crud_tut/pages/single_user_page.dart';
import 'package:flutter_firebase_crud_tut/pages/update_user.dart';

import '../models/user.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _readUsers() =>
      FirebaseFirestore.instance
          .collection('users')
          .snapshots()
          .map((snapshot) => snapshot.docs);
  // .map((snapshot) =>
  //     snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: StreamBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
        stream: _readUsers(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final docs = snapshot.data!;

            return ListView(
                children: docs.map((doc) {
              final user = User(
                id: doc.data()['id'],
                name: doc.data()['name'],
                age: doc.data()['age'],
                birthday: (doc.data()['birthday'] as Timestamp).toDate(),
              );

              return buildUser(user, context);
            }).toList());
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const AddUserPage(),
                ));
              },
              child: const Icon(Icons.add)),
          const SizedBox(height: 10),
          FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SingleUser(),
                ));
              },
              child: const Icon(
                Icons.search,
              )),
        ],
      ),
    );
  }

  Widget buildUser(User user, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpdateUserPage(
                        user: user,
                      ))),
              leading: CircleAvatar(child: Text(user.age.toString())),
              title: Text(user.name),
              trailing: Text(user.birthday.toIso8601String())),
        ),
        const SizedBox(width: 10),
        IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () => _deleteUser(user.id))
      ],
    );
  }

  Future _deleteUser(String? id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .delete();
  }
}
