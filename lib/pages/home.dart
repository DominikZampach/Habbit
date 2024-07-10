import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/pages/login.dart';
import 'package:habbit_app/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = AuthService().currentUser;

  Future<void> signOut() async {
    await AuthService().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            user?.email ?? 'User email',
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
              onPressed: () async {
                await signOut();
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              child: Text("Sign out"))
        ],
      ),
    );
  }
}
