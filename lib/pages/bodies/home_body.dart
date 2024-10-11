import 'package:flutter/material.dart';
import 'package:habbit_app/models/database_user.dart';
import 'package:habbit_app/models/habit.dart';
import 'package:habbit_app/services/database.dart';
import 'package:habbit_app/widgets/habit_card.dart';

class HomeBody extends StatefulWidget {
  final DatabaseUser? dbUser;
  final DatabaseService dbService;
  const HomeBody({super.key, required this.dbUser, required this.dbService});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late int numberOfHabits = 0;
  late int numberOfCompletedHabits = 0;
  int dayToday = DateTime.now().weekday;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.dbUser!.habitsInClass.length; i++) {
      if (Habit.findHabitByIndex(widget.dbUser!, i)!
          .daysToDo
          .contains(dayToday.toString())) {
        numberOfHabits += 1;
      }
    }
    for (int i = 0; i < widget.dbUser!.habitsInClass.length; i++) {
      if (widget.dbUser!.habitsInClass[i].isHabitDoneToday()) {
        numberOfCompletedHabits += 1;
      }
    }
  }

  void updateHabitsCount() {
    setState(() {
      // Recalculate the number of completed habits
      numberOfCompletedHabits = 0;
      for (var habit in widget.dbUser!.habitsInClass) {
        if (habit.isHabitDoneToday()) {
          numberOfCompletedHabits += 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dbUser!.habitsInClass.isEmpty) {
      return const Text("0 habits, go create some!");
    }
    return SingleChildScrollView(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text(
                  "$numberOfCompletedHabits/$numberOfHabits completed!",
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            for (int i = 0; i < widget.dbUser!.habitsInClass.length; i++)
              // Check if today is the day of the week that user have selected in daysToDo
              if (Habit.findHabitByIndex(widget.dbUser!, i)!
                  .daysToDo
                  .contains(dayToday.toString()))
                HabitCard(
                  dbService: widget.dbService,
                  positionIndex: i,
                  user: widget.dbUser!,
                  onHabitToggled: updateHabitsCount,
                ),
          ],
        ),
      ),
    );
  }
}
