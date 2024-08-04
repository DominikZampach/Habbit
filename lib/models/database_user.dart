import 'package:habbit_app/models/habit.dart';

class DatabaseUser {
  List<Habit> habitsInClass;
  String userUid;

  DatabaseUser({
    required this.habitsInClass,
    required this.userUid,
  });

  DatabaseUser.fromJson(Map<String, Object?> json)
      : userUid = json['userUid']! as String,
        habitsInClass = (json['habits'] as List<dynamic>)
            .map((e) => Habit.fromJson(e as Map<String, Object?>))
            .toList();

  Map<String, Object?> toJson() {
    return {
      'userUid': userUid,
      'habits': habitsInClass.map((habit) => habit.toJson()).toList(),
    };
  }
}
