import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/notes.dart';
import '../utils/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: _isSigningIn
            ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.grey),
              )
            : TextButton(
                child: Text('Sign in',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white)),
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: Colors.grey,
                  elevation: 5,
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningIn = true;
                  });

                  User? user = await Authentication.signInWithGoogle();

                  if (user != null) {
                    setState(() {
                      _isSigningIn = false;
                    });

                    Get.off(
                      () => MyNotes(user: user),
                    );
                  }
                },
              ));
  }
}
