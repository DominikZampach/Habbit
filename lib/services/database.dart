import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habbit_app/models/database_user.dart';

const USERS_COLLECTION_REF = "users";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _usersRef;

  DatabaseService() {
    _usersRef = _firestore
        .collection(USERS_COLLECTION_REF)
        .withConverter<DatabaseUser>(
            fromFirestore: (snapshots, _) =>
                DatabaseUser.fromJson(snapshots.data()!),
            toFirestore: (user, _) => user.toJson());
  }

  Stream<QuerySnapshot> getAllUsers() {
    return _usersRef.snapshots();
  }

  Future<DatabaseUser?> getUser(String userUid) async {
    DocumentReference userRef = _usersRef.doc(userUid);

    try {
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        DatabaseUser? loadedDbUser = DatabaseUser.fromJson(userData);
        print("data from Firebase" + loadedDbUser.userUid);
        return loadedDbUser;
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
}
