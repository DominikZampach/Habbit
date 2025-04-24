import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/models/database_user.dart';
import 'package:habbit_app/models/habit.dart';
import 'package:habbit_app/services/database.dart';
import 'package:habbit_app/widgets/edit_habit.dart';
import 'package:habbit_app/widgets/toast.dart';

class HabitEditCard extends StatefulWidget {
  final int positionIndex;
  final DatabaseUser user;
  final DatabaseService dbService;
  final Function updateEditBody;

  const HabitEditCard({
    super.key,
    required this.positionIndex,
    required this.user,
    required this.dbService,
    required this.updateEditBody,
  });

  @override
  State<HabitEditCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitEditCard> {
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
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => EditHabit(
                    habit: habit,
                    user: widget.user,
                    dbService: widget.dbService,
                  ),
            ),
          ),
      child: Dismissible(
        key: widget.key!,
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) async {
          // Delete the habit
          if (direction.name == "startToEnd") {
            setState(() {
              widget.user.habitsInClass.remove(habit);
            });

            await widget.dbService.deleteHabit(widget.user, habit);
            showToast("Habit named ${habit.name} deleted");
            //sleep(const Duration(milliseconds: 500));
            widget.updateEditBody();
          }
        },
        background: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(5.0),
          width: MediaQuery.of(context).size.width * 0.92,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.red,
          ),
        ),
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
                  makeShorterName(habit.name),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primary, fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String makeShorterName(String name) {
    if (name.length > 22) {
      return ("${name.substring(0, 22)}...");
    } else {
      return name;
    }
  }
}
