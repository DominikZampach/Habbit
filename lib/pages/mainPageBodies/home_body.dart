import 'package:flutter/material.dart';
import 'package:habbit_app/models/database_user.dart';
import 'package:habbit_app/models/habit.dart';
import 'package:habbit_app/services/database.dart';
import 'package:habbit_app/widgets/habit_card.dart';

class HomeBody extends StatefulWidget {
  final DatabaseUser? dbUser;
  const HomeBody({super.key, required this.dbUser});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  late int numberOfHabits;
  late int numberOfCompletedHabits = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    numberOfHabits = widget.dbUser!.habitsInClass.length;
    for (int i = 0; i < numberOfHabits; i++) {
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
      child: Container(
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
              HabitCard(
                habitId: i,
                user: widget.dbUser!,
                onHabitToggled: updateHabitsCount,
              ),
            Text(widget.dbUser!.habitsInClass[0].name),
            Icon(
              iCONS[widget.dbUser!.habitsInClass[0].iconIndex],
              size: 30.0,
            ),
            ElevatedButton(
                onPressed: () {
                  if (widget.dbUser!.habitsInClass[0].name == "Skibidi") {
                    widget.dbUser!.habitsInClass[0].name =
                        "Fortnite balls skibidi toilet rizz sigma female";
                  } else {
                    widget.dbUser!.habitsInClass[0].name = "Skibidi";
                  }
                  setState(() {
                    DatabaseService().updateUser(widget.dbUser!);
                  });
                },
                child: const Text("Change name"))
          ],
        ),
      ),
    );
  }
}
