import 'package:flutter/material.dart';
import 'package:habbit_app/models/database_user.dart';

class HomeBody extends StatefulWidget {
  final DatabaseUser? dbUser;
  const HomeBody({super.key, required this.dbUser});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.dbUser!.habitsInClass[0].name),
        Text(widget.dbUser!.habitsInClass[0].isHabitDoneToday().toString())
      ],
    );
  }
}
