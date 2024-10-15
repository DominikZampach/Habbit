import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/custom_icons.dart';
import 'package:habbit_app/models/database_user.dart';

class Habit {
  String name;
  String category;
  String daysToDo;
  List<Timestamp> daysDone;
  String note;
  Map<String, String> notes;
  Timestamp notificationTime;
  String iconName;
  int positionIndex;

  Habit(
      {required this.name,
      required this.category,
      required this.daysToDo,
      required this.daysDone,
      required this.note,
      required this.notes,
      required this.notificationTime,
      required this.iconName,
      required this.positionIndex});

  Habit.fromJson(Map<String, Object?> json) // Převod JSON objektu na Class
      : this(
            name: json['name']! as String,
            category: json['category']! as String,
            daysToDo: json['daysToDo']! as String,
            daysDone: (json['daysDone'] as List<dynamic>)
                .map((e) => e as Timestamp)
                .toList(),
            note: json['note']! as String,
            notes: Map<String, String>.from(json['notes']! as Map),
            notificationTime: json['notificationTime']! as Timestamp,
            iconName: json['iconIndex']! as String,
            positionIndex: json['positionIndex']! as int);

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'category': category,
      'daysToDo': daysToDo,
      'daysDone': daysDone,
      'note': note,
      'notes': notes,
      'notificationTime': notificationTime,
      'iconName': iconName,
      'positionIndex': positionIndex
    };
  }

  bool isHabitDoneToday() {
    //Checks if the habit was completed today
    DateTime now = DateTime.now();
    DateTime todayDate = DateTime(now.year, now.month, now.day, 2);
    print("today's date: ${todayDate.toString()}");
    print("days: ${daysDone.length}");

    for (int index = 0; index < daysDone.length; index++) {
      DateTime doneDate = daysDone[index].toDate();
      DateTime doneDateWithSetTime =
          DateTime(doneDate.year, doneDate.month, doneDate.day, 2);

      print(doneDateWithSetTime);

      if (doneDateWithSetTime == todayDate) {
        return true;
      }
    }

    return false;
  }

  bool isHabitDoneThisDate(DateTime date) {
    // TODO: Create this instead of method up
    return false;
  }

  IconData getHabitsIcon() {
    return myCustomIcons[iconName]!;
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
