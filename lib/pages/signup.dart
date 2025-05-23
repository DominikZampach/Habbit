import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/pages/login.dart';
import 'package:habbit_app/services/auth.dart';
import 'package:habbit_app/widgets/kralicek.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: _signin(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Kralicek(height: 80.0, padding: 25.0),
                  const Text(
                    "Register to\nHabbit",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  _emailField(),
                  const SizedBox(height: 20.0),
                  _passwordField(),
                  const SizedBox(height: 35.0),
                  _signupButton(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _signupButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService().signup(
          email: _emailController.text,
          password: _passwordController.text,
          context: context,
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: primary,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Sign up",
          style: TextStyle(fontSize: 30.0, color: background),
        ),
      ),
    );
  }

  Padding _passwordField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Password",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: secondary.withValues(alpha: 0.4),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.normal,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Padding _emailField() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "E-mail",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.normal,
              fontSize: 24.0,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              filled: true,
              hintText: 'example@gmail.com',
              hintStyle: TextStyle(
                color: primary,
                fontWeight: FontWeight.w300,
                fontSize: 20.0,
              ),
              fillColor: secondary.withValues(alpha: 0.4),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.normal,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _signin(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "Already have an account? ",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            TextSpan(
              text: "Log in",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
              recognizer:
                  TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login()),
                      );
                    },
            ),
          ],
        ),
      ),
    );
  }
}
