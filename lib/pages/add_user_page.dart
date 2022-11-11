import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_crud_tut/models/user.dart';

class AddUserPage extends StatelessWidget {
  const AddUserPage({super.key});

  Future _createUser(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc();
    user.id = userDoc.id;

    final json = user.toJson();

    await userDoc.set(json);
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final birthdayController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('User Page')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                  controller: ageController,
                  decoration: const InputDecoration(hintText: 'Age')),
              const SizedBox(height: 10),
              TextField(
                controller: birthdayController,
                decoration:
                    const InputDecoration(hintText: 'Birthday (YYYY-MM-DD)'),
              ),
              const SizedBox(height: 20),
              TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50)),
                  onPressed: () {
                    final user = User(
                        name: nameController.text,
                        age: int.parse(ageController.text),
                        birthday: DateTime.parse(birthdayController.text));

                    _createUser(user);
                    nameController.clear();
                    ageController.clear();
                    birthdayController.clear();
                  },
                  child: const Text('Create',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUser(User user) {
    return ListTile(
      leading: CircleAvatar(child: Text(user.age.toString())),
      title: Text(user.name),
      trailing: Text(user.birthday.toIso8601String()),
    );
  }
}
