import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habbit_app/models/database_user.dart';
import 'package:habbit_app/models/habit.dart';

// ignore: constant_identifier_names
const USERS_COLLECTION_REF = "users";

class DatabaseService {
  late final CollectionReference<DatabaseUser> _usersRef;

  DatabaseService() {
    // Using the withConverter method to properly map the Firestore data
    final FirebaseApp app = FirebaseAuth.instance.app;
    final firestore = FirebaseFirestore.instanceFor(app: app);
    _usersRef =
        firestore.collection(USERS_COLLECTION_REF).withConverter<DatabaseUser>(
              fromFirestore: (snapshot, _) {
                final data = snapshot.data();
                if (data != null) {
                  return DatabaseUser.fromJson(data); // Ensure proper cast
                } else {
                  throw Exception("Data not found in snapshot");
                }
              },
              toFirestore: (user, _) =>
                  user.toJson(), // Convert DatabaseUser to Map<String, dynamic>
            );
  }

  Stream<QuerySnapshot> getAllUsers() {
    return _usersRef.snapshots();
  }

  Future<DatabaseUser?> getUser(String userUid) async {
    DocumentReference<DatabaseUser> userRef = _usersRef.doc(userUid);

    try {
      DocumentSnapshot<DatabaseUser> userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        return userSnapshot.data();
      } else {
        // Create a new user if no such document exists
        // TODO Opravit tuhle mrdku
        DatabaseUser newUser =
            DatabaseUser(habitsInClass: [], userUid: userUid);
        await addUser(newUser); // Wait for user to be added to Firestore
        print('No such document, created new user');
        return newUser;
      }
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }

  Future<void> addUser(DatabaseUser user) async {
    await _usersRef.doc(user.userUid).set(user); // .set(user.toJson());
  }

  void updateUser(DatabaseUser user) async {
    await _usersRef.doc(user.userUid).update(user.toJson());
    print("Completed user update");
  }

  Future<void> deleteHabit(DatabaseUser user, Habit habit) async {
    int indexOfHabit = habit.positionIndex;
    user.habitsInClass.remove(habit);
    for (Habit habit in user.habitsInClass) {
      if (habit.positionIndex > indexOfHabit) {
        habit.positionIndex -= 1;
      }
    }
    _usersRef.doc(user.userUid).update(user.toJson());
  }
}
