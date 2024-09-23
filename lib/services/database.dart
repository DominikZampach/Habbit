import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habbit_app/models/database_user.dart';

const USERS_COLLECTION_REF = "users";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference<DatabaseUser> _usersRef;

  DatabaseService() {
    // Using the withConverter method to properly map the Firestore data
    _usersRef =
        _firestore.collection(USERS_COLLECTION_REF).withConverter<DatabaseUser>(
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
}
