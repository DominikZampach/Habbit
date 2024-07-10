import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/pages/home.dart';

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

      await Future.delayed(const Duration(milliseconds: 500));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
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

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 20.0,
        textColor: secondary,
      );
    } on PlatformException catch (e) {
      // Handle PlatformException if needed
      String message = '';
      print("PlatformException caught: ${e.code}, ${e.message}");

      if (e.code == 'ERROR_WEAK_PASSWORD') {
        message = "Password should be at least 6 characters";
      } else if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        message = e.message!;
      } else {
        message = "An unknown error occurred: ${e.message}";
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 20.0,
        textColor: secondary,
      );
    } catch (e) {
      print("An unexpected error occurred: $e"); // Catch any other exceptions
      Fluttertoast.showToast(
        msg: "An unexpected error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 20.0,
        textColor: secondary,
      );
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

      await Future.delayed(const Duration(milliseconds: 500));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) => HomePage()));
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

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 20.0,
        textColor: secondary,
      );
    } catch (e) {
      print("An unexpected error occurred: $e"); // Catch any other exceptions
      Fluttertoast.showToast(
        msg: "An unexpected error occurred: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        fontSize: 20.0,
        textColor: secondary,
      );
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
