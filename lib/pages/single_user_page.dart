import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

class SingleUser extends StatefulWidget {
  const SingleUser({super.key});

  @override
  State<SingleUser> createState() => _SingleUserState();
}

class _SingleUserState extends State<SingleUser> {
  String tempID = '';
  Future<User?>? user;

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Get User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          TextField(
            controller: idController,
            decoration: const InputDecoration(hintText: 'Search by ID'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50)),
            onPressed: () {
              if (idController.text.isNotEmpty) {
                tempID = idController.text;
                setState(() {
                  user = _fetchUser(tempID);
                });
              } else {
                setState(() {
                  user = null;
                });
              }
            },
            child: const Text(
              'Fetch',
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
              height: 50,
              child: user != null
                  ? FutureBuilder(
                      future: _fetchUser(tempID.trim()),
                      builder: (_, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Something went wrong'),
                          );
                        } else if (snapshot.hasData) {
                          final user = snapshot.data!;

                          return buildUser(user);
                        } else {
                          return const Center(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                      })
                  : const SizedBox()),
        ]),
      ),
    );
  }

  Future<User?>? _fetchUser(String id) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(id);

    final json = await userDoc.get();

    if (json.exists) {
      debugPrint('Yay');
      return User.fromJson(json.data()!);
    } else {
      debugPrint('Nay');
      return null;
    }
  }

  Widget buildUser(User user) {
    return ListTile(
      leading: CircleAvatar(child: Text(user.age.toString())),
      title: Text(user.name),
      trailing: Text(user.birthday.toIso8601String()),
    );
  }
}
