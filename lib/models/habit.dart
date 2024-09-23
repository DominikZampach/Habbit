import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const List<IconData> iCONS = [
  Icons.access_time,
  Icons.airplanemode_active_rounded,
  Icons.audiotrack,
  Icons.flag,
  Icons.beach_access,
  Icons.bed,
  Icons.call,
  Icons.build,
  Icons.camera_alt,
  Icons.card_travel,
  Icons.chat,
  Icons.child_friendly,
  Icons.cloud,
  Icons.computer,
  Icons.directions_bike,
  Icons.directions_car,
  Icons.directions_run,
  Icons.directions_walk,
  Icons.email,
  Icons.explore,
  Icons.domain,
  Icons.favorite,
  Icons.pets,
  Icons.restaurant,
  Icons.school,
  Icons.shopping_bag,
  Icons.shopping_cart,
  Icons.toys,
  Icons.phone_android,
  Icons.vpn_key,
  Icons.watch
];

class Habit {
  String name;
  String category;
  String daysToDo;
  int streak;
  List<Timestamp> daysDone;
  String note;
  Map<String, String> notes;
  Timestamp notificationTime;
  int iconIndex;

  Habit(
      {required this.name,
      required this.category,
      required this.daysToDo,
      required this.streak,
      required this.daysDone,
      required this.note,
      required this.notes,
      required this.notificationTime,
      required this.iconIndex});

  Habit.fromJson(Map<String, Object?> json) // Převod JSON objektu na Class
      : this(
            name: json['name']! as String,
            category: json['category']! as String,
            daysToDo: json['daysToDo']! as String,
            streak: json['streak']! as int,
            daysDone: (json['daysDone'] as List<dynamic>)
                .map((e) => e as Timestamp)
                .toList(),
            note: json['note']! as String,
            notes: Map<String, String>.from(json['notes']! as Map),
            notificationTime: json['notificationTime']! as Timestamp,
            iconIndex: json['iconIndex']! as int);

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'category': category,
      'daysToDo': daysToDo,
      'streak': streak,
      'daysDone': daysDone,
      'note': note,
      'notes': notes,
      'notificationTime': notificationTime,
      'iconIndex': iconIndex
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
    return iCONS[iconIndex];
  }
}
