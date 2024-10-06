import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
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
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _nameField(),
          // Days to do
          // Select icon and save iconIndex
          // Note
          // Select category: Morning, Afternoon, Evening
          // Notification time
          ElevatedButton(
              onPressed: _createHabitFunc, child: const Text("Create Habit"))
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "New Habbit",
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      centerTitle: true,
      toolbarHeight: 80.0,
    );
  }

  Padding _nameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Habit name",
            style: TextStyle(
                color: primary, fontWeight: FontWeight.normal, fontSize: 24.0),
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
