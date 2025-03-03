import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/models/database_user.dart';
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
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (int i = 0; i < widget.dbUser!.habitsInClass.length; i++)
                  // Check if today is the day of the week that user have selected in daysToDo
                  HabitEditCard(
                    dbService: widget.dbService,
                    positionIndex: i,
                    user: widget.dbUser!,
                    updateEditBody: setStateEditBody,
                  ),
              ],
            ),
          ),
        ));
  }

  Padding _floatingButtonEditBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddHabitPage(
                      dbService: widget.dbService, dbUser: widget.dbUser))),
          //onPressed: () => showDialog(
          //    context: context,
          //    builder: (context) {
          //      return const AddHabitDialog();
          //    }),
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
