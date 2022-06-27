import 'package:flutter/material.dart';

import '../custom_widgets/sign_in_button.dart';
import '../utils/authentication.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 370,
              ),
              FutureBuilder(
                future: Authentication.initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return GoogleSignInButton();
                  }
                  return CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
