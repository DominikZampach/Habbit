import 'package:flutter/material.dart';
import 'package:habbit_app/services/auth.dart';

class SettingsBody extends StatefulWidget {
  final AuthService _authService = AuthService();

  SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () {
            widget._authService.signOut();
          },
          child: const Text("Logout")),
    );
  }
}
