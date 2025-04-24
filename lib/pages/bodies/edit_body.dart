import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/models/database_user.dart';
import 'package:habbit_app/models/habit.dart';
import 'package:habbit_app/pages/add_habit.dart';
import 'package:habbit_app/services/database.dart';
import 'package:habbit_app/widgets/habit_edit_card.dart';

class EditBody extends StatefulWidget {
  final DatabaseService dbService;
  final DatabaseUser? dbUser;

  const EditBody({super.key, required this.dbService, required this.dbUser});

  @override
  State<EditBody> createState() => _EditBodyState();
}

class _EditBodyState extends State<EditBody> {
  int dayToday = DateTime.now().weekday;

  @override
  void dispose() {
    super.dispose();
  }

  void setStateEditBody() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _floatingButtonEditBody(context),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ReorderableListView.builder(
            itemCount: widget.dbUser!.habitsInClass.length,
            onReorder:
                (oldIndex, newIndex) => setState(() {
                  if (newIndex > oldIndex) newIndex -= 1;

                  final habitList = widget.dbUser!.habitsInClass;

                  final movedHabit = habitList.firstWhere(
                    (h) => h.positionIndex == oldIndex,
                  );

                  // posuň ostatní tak, aby nedošlo ke kolizi pozic
                  for (var h in habitList) {
                    if (oldIndex < newIndex) {
                      if (h.positionIndex > oldIndex &&
                          h.positionIndex <= newIndex) {
                        h.positionIndex -= 1;
                      }
                    } else {
                      if (h.positionIndex < oldIndex &&
                          h.positionIndex >= newIndex) {
                        h.positionIndex += 1;
                      }
                    }
                  }

                  movedHabit.positionIndex = newIndex;
                }),
            itemBuilder: (context, index) {
              final habit = widget.dbUser!.habitsInClass.firstWhere(
                (h) => h.positionIndex == index,
              );

              return Center(
                key: ValueKey(
                  '${habit.name}_${widget.dbUser!.habitsInClass.indexOf(habit)}',
                ),
                child: HabitEditCard(
                  key: ValueKey(
                    '${habit.name}_${widget.dbUser!.habitsInClass.indexOf(habit)}',
                  ),
                  dbService: widget.dbService,
                  positionIndex: index,
                  user: widget.dbUser!,
                  updateEditBody: setStateEditBody,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Padding _floatingButtonEditBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AddHabitPage(
                      dbService: widget.dbService,
                      dbUser: widget.dbUser,
                    ),
              ),
            ),
        //onPressed: () => showDialog(
        //    context: context,
        //    builder: (context) {
        //      return const AddHabitDialog();
        //    }),
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(12.0),
          backgroundColor: secondary.withOpacity(0.5),
        ),
        child: Icon(Icons.add, size: 45, color: primary),
      ),
    );
  }
}
