import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class UpdateUserPage extends StatelessWidget {
  const UpdateUserPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController birthdayController = TextEditingController();
    nameController.text = user.name;
    ageController.text = user.age.toString();
    birthdayController.text = user.birthday.toIso8601String();

    return Scaffold(
      appBar: AppBar(title: const Text('Update User')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                  final payload = {
                    'name': nameController.text,
                    'age': int.parse(ageController.text),
                    'birthday': DateTime.parse(birthdayController.text)
                  };

                  _updateUser('mQu844406csRnDitngBT', payload);
                  nameController.clear();
                  ageController.clear();
                  birthdayController.clear();
                },
                child: const Text('Update',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ))),
          ],
        ),
      ),
    );
  }

  Future _updateUser(String id, Map<String, dynamic> payload) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(id);

    userDoc.update(payload);
  }
}
