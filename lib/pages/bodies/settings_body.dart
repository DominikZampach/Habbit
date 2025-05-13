import 'package:flutter/material.dart';
import 'package:habbit_app/services/auth.dart';
import 'package:habbit_app/services/notification_services.dart';

class SettingsBody extends StatefulWidget {
  final AuthService _authService = AuthService();

  SettingsBody({super.key});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              widget._authService.signOut(context);
            },
            child: const Text("Logout"),
          ),
          ElevatedButton(
            onPressed: () {
              NotifiService().showNotification(
                title: "Test notifikace",
                body: "Random obsah notifikace",
              );
            },
            child: Text("Notification Test"),
          ),
        ],
      ),
    );
  }
}
