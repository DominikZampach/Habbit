import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/models/database_user.dart';
import 'package:habbit_app/models/habit.dart';
import 'package:habbit_app/services/database.dart';

class HabitCard extends StatefulWidget {
  final int positionIndex;
  final DatabaseUser user;
  final Function onHabitToggled;
  final DatabaseService dbService;

  HabitCard(
      {super.key,
      required this.positionIndex,
      required this.user,
      required this.onHabitToggled,
      required this.dbService});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  late IconData icon;
  late bool todayCompleted;
  late Habit habit;
  late int listPosition;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    for (int i = 0; i < widget.user.habitsInClass.length; i++) {
      if (widget.user.habitsInClass[i].positionIndex == widget.positionIndex) {
        habit = widget.user.habitsInClass[i];
        listPosition = i;
      }
    }
    icon = habit.getHabitsIcon();
    todayCompleted = habit.isHabitDoneToday();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width * 0.92,
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: secondary),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
            size: 30,
          ),
          Expanded(
            child: Text(
              makeShorterName(habit.name),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primary,
                fontSize: 22,
              ),
            ),
          ),
          _checkbox()
        ],
      ),
    );
  }

  Checkbox _checkbox() {
    return Checkbox(
        value: todayCompleted,
        checkColor: primary,
        shape: const CircleBorder(),
        onChanged: ((value) => onChangedCheckboxLogic(value)));
  }

  void onChangedCheckboxLogic(value) {
    DateTime today = DateTime
        .now(); // TODO: This also needs to be adjusted to usage for more than 1 day (like user can scroll in calendar and fix some days)
    today = DateTime(today.year, today.month, today.day);
    // This mades it set to date + 02:00:00, but it is alright, I will work with it
    // Hope it will work even in winter/summer time 💀
    setState(() {
      todayCompleted = value!;
      if (value == true) {
        habit.daysDone.add(Timestamp.fromDate(today));
      } else {
        habit.daysDone.remove(Timestamp.fromDate(today));
      }
      widget.user.habitsInClass[listPosition] = habit;
      widget.dbService.updateUser(widget.user);
    });
    widget.onHabitToggled();
  }

  String makeShorterName(String name) {
    if (name.length > 22) {
      return ("${name.substring(0, 22)}...");
    } else {
      return name;
    }
  }
}
