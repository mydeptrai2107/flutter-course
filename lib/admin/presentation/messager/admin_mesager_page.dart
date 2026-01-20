import 'package:app/page/login_screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminMesagerPage extends StatefulWidget {
  const AdminMesagerPage({super.key});

  @override
  State<AdminMesagerPage> createState() => _AdminMesagerPageState();
}

class _AdminMesagerPageState extends State<AdminMesagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tin nhắn'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreens()),
              );
            },
            icon: const Icon(Icons.logout, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
