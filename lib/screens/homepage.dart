import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signOut(){
    FirebaseAuth.instance.signOut();
    // AuthService.signOutGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        actions: [IconButton(onPressed: signOut, icon: Icon(Icons.logout), color: Colors.red,)]
        ),
      body: Center(
        child: Text("LOGGED IN AS: " + user.email!, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}