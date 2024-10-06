import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/pages/bodies/add_habit_new.dart';

class EditBody extends StatefulWidget {
  const EditBody({super.key});

  @override
  State<EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBody> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingButtonEditBody(context),
    );
  }

  Padding _floatingButtonEditBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
          //onPressed: () => Navigator.push(context,
          //    MaterialPageRoute(builder: (context) => const AddHabitPage())),
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                return const AddHabitDialog();
              }),
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12.0),
              backgroundColor: secondary.withOpacity(0.5)),
          child: Icon(
            Icons.add,
            size: 45,
            color: primary,
          )),
    );
  }
}
