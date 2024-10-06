import 'package:flutter/material.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  @override
  Widget build(BuildContext context) {
    return const AlertDialog(
      title: Center(child: Text("Add habit")),
    );
  }
}
