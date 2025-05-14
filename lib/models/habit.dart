import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/custom_icons.dart';
import 'package:habbit_app/models/database_user.dart';

class Habit {
  String name;
  String daysToDo;
  List<Timestamp> daysDone;
  String note;
  Timestamp notificationTime;
  String iconName;
  int positionIndex;

  Habit({
    required this.name,
    required this.daysToDo,
    required this.daysDone,
    required this.note,
    required this.notificationTime,
    required this.iconName,
    required this.positionIndex,
  });

  Habit.fromJson(Map<String, Object?> json) // Převod JSON objektu na Class
    : this(
        name: json['name']! as String,
        daysToDo: json['daysToDo']! as String,
        daysDone:
            (json['daysDone'] as List<dynamic>)
                .map((e) => e as Timestamp)
                .toList(),
        note: json['note']! as String,
        notificationTime: json['notificationTime']! as Timestamp,
        iconName: json['iconName']! as String,
        positionIndex: json['positionIndex']! as int,
      );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'daysToDo': daysToDo,
      'daysDone': daysDone,
      'note': note,
      'notificationTime': notificationTime,
      'iconName': iconName,
      'positionIndex': positionIndex,
    };
  }

  bool isHabitDoneToday() {
    //Checks if the habit was completed today
    DateTime now = DateTime.now().toUtc();
    DateTime todayDate = DateTime.utc(now.year, now.month, now.day);

    for (int index = 0; index < daysDone.length; index++) {
      DateTime doneDate = daysDone[index].toDate().toUtc();
      DateTime doneDateWithSetTime = DateTime.utc(
        doneDate.year,
        doneDate.month,
        doneDate.day,
      );

      print(doneDateWithSetTime);

      if (doneDateWithSetTime == todayDate) {
        return true;
      }
    }

    return false;
  }

  bool isHabitDoneThisDate(DateTime date) {
    // TODO: Create this instead of method up here
    return false;
  }

  IconData getHabitsIcon() {
    return myCustomIcons[iconName]!.data;
  }

  static Habit? findHabitByIndex(DatabaseUser user, positionIndex) {
    for (int i = 0; i < user.habitsInClass.length; i++) {
      if (user.habitsInClass[i].positionIndex == positionIndex) {
        return user.habitsInClass[i];
      }
    }
    return null;
  }
}
