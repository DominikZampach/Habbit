import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/models/database_user.dart';
import 'package:habbit_app/services/database.dart';

class HabitCard extends StatefulWidget {
  final int habitId;
  final DatabaseUser user;
  final Function onHabitToggled;
  final DatabaseService _databaseService = DatabaseService();

  HabitCard(
      {super.key,
      required this.habitId,
      required this.user,
      required this.onHabitToggled});

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  late IconData icon;
  late bool todayCompleted;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    icon = widget.user.habitsInClass[widget.habitId].getHabitsIcon();
    todayCompleted =
        widget.user.habitsInClass[widget.habitId].isHabitDoneToday();
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
              makeShorterName(widget.user.habitsInClass[widget.habitId].name),
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
        widget.user.habitsInClass[widget.habitId].daysDone
            .add(Timestamp.fromDate(today));
        widget._databaseService.updateUser(widget.user);
      } else {
        widget.user.habitsInClass[widget.habitId].daysDone
            .remove(Timestamp.fromDate(today));
        widget._databaseService.updateUser(widget.user);
      }
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
