import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/widgets/kralicek.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  late TextEditingController _controllerName;
  late String name = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _controllerName = TextEditingController(text: name);
    super.initState();
  }

  void _createHabitFunc() {
    // TODO: This also needs to check how long is the name of the habit
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text("Add habit")),
      icon: const Kralicek(height: 40.0, padding: 0.0),
      content: Column(
        children: [
          _nameField(),
          // Days to do
          // Select icon and save iconIndex
          // Note
          // Select category: Morning, Afternoon, Evening
          // Notification time
        ],
      ),
    );
  }

  Padding _nameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Habit name",
            style: TextStyle(
                color: primary, fontWeight: FontWeight.normal, fontSize: 20.0),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _controllerName,
            obscureText: false,
            decoration: InputDecoration(
                filled: true,
                fillColor: secondary.withOpacity(0.4),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10))),
            style: TextStyle(
                color: primary, fontWeight: FontWeight.normal, fontSize: 20.0),
          )
        ],
      ),
    );
  }
}
