import 'package:app/page/login_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminMessenderPage extends StatefulWidget {
  const AdminMessenderPage({super.key});

  @override
  State<AdminMessenderPage> createState() => _AdminMessenderPageState();
}

class _AdminMessenderPageState extends State<AdminMessenderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin Nhắn'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreens()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
