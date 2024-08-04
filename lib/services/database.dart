import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habbit_app/models/database_user.dart';

const String USERS_COLLECTION_REF = "users";

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
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userRef = firestore.collection('users').doc(userUid);

    try {
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        Map<String, Object?> userData =
            userSnapshot.data() as Map<String, Object?>;
        return DatabaseUser.fromJson(userData);
      } else {
        print('No such document!');
        return null;
      }
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }

  void addUser(DatabaseUser user) async {
    await _usersRef.doc(user.userUid).set(user.toJson());
  }
}
