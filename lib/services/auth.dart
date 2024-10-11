import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/pages/home.dart';
import 'package:habbit_app/pages/login.dart';
import 'package:habbit_app/widgets/toast.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signup(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      print("FirebaseAuthException caught: ${e.code}, ${e.message}");

      switch (e.code) {
        case 'weak-password':
          message = "Password should be at least 6 characters";
          break;
        case 'email-already-in-use':
          message = "The email address is already in use by another account.";
          break;
        case 'invalid-email':
          message = "The email address is not valid.";
          break;
        case 'operation-not-allowed':
          message = "Email/Password accounts are not enabled.";
          break;
        default:
          message = "An unknown error occurred: ${e.message}";
      }

      showToast(message);
    } catch (e) {
      showToast("An unexpected error occurred: $e");
    }
  }

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      print("FirebaseAuthException caught: ${e.code}, ${e.message}");

      switch (e.code) {
        case 'user-not-found':
          message = "User not found.";
          break;
        case 'wrong-password':
          message = "You entered wrong password.";
          break;
        case 'invalid-email':
          message = "The email address is not valid.";
          break;
        case 'operation-not-allowed':
          message = "Email/Password accounts are not enabled.";
          break;
        default:
          message = "An unknown error occurred: ${e.message}";
      }

      showToast(message);
    } catch (e) {
      showToast("An unexpected error occurred: $e");
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _firebaseAuth.signOut();

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false);
    }
  }
}
