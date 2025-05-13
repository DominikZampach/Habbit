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

  const HabitCard({
    super.key,
    required this.positionIndex,
    required this.user,
    required this.onHabitToggled,
    required this.dbService,
  });

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
    if (habit.isHabitDoneToday()) return habitCardDone(context);

    return habitCardNotDone(context);
  }

  GestureDetector habitCardNotDone(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapHabitCard(context),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(5.0),
        width: MediaQuery.of(context).size.width * 0.92,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: secondary,
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 30),
            Expanded(
              child: Text(
                habit.name,
                textAlign: TextAlign.center,
                style: TextStyle(color: primary, fontSize: 22),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            _checkbox(),
          ],
        ),
      ),
    );
  }

  GestureDetector habitCardDone(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTapHabitCard(context),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(5.0),
        width: MediaQuery.of(context).size.width * 0.92,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: cRed.withValues(alpha: 0.8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 30),
            Expanded(
              child: Text(
                habit.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primary,
                  fontSize: 22,
                  decoration: TextDecoration.lineThrough,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
            ),
            _checkbox(),
          ],
        ),
      ),
    );
  }

  void _onTapHabitCard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black87.withValues(alpha: 0.5),
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "More information about '${habit.name}'",
                style: TextStyle(fontSize: 25.0),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Checkbox _checkbox() {
    return Checkbox(
      value: todayCompleted,
      checkColor: primary,
      shape: const CircleBorder(),
      onChanged: ((value) => onChangedCheckboxLogic(value)),
    );
  }

  void onChangedCheckboxLogic(value) {
    DateTime today = DateTime.now().toUtc();
    today = DateTime.utc(today.year, today.month, today.day, 0, 0, 0, 0, 0);
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
}
