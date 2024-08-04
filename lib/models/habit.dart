import 'package:cloud_firestore/cloud_firestore.dart';

class Habit {
  String name;
  String category;
  String daysToDo;
  int streak;
  List<Timestamp> daysDone;
  String note;
  Map<String, String> notes;
  Timestamp notificationTime;

  Habit(
      {required this.name,
      required this.category,
      required this.daysToDo,
      required this.streak,
      required this.daysDone,
      required this.note,
      required this.notes,
      required this.notificationTime});

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
            notificationTime: json['notificationTime']! as Timestamp);

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
    };
  }
}
