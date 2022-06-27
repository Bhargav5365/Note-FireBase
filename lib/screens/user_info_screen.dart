import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notefirebase/screens/sign_in_screen.dart';

import '../utils/authentication.dart';

class UserInfoScreen extends StatefulWidget {
  final User? _user;
  const UserInfoScreen({Key? key, User? user})
      : _user = user,
        super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  User? _user;
  bool _isSigningOut = false;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 157,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 2.0,
                          top: 2.0,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            color: Colors.black87,
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, 15),
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2.5),
                      image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                            _user!.photoURL!,
                          )),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Text(
              _user!.displayName!,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 11),
            Text(
              '${_user!.email}',
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                  fontSize: 20),
            ),
            SizedBox(height: 23),
            Spacer(),
            _isSigningOut
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  )
                : Padding(
                    padding: EdgeInsets.only(
                      bottom: 24,
                    ),
                    child: TextButton(
                      child: Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.grey,
                        elevation: 2,
                      ),
                      onPressed: () async {
                        setState(() {
                          _isSigningOut = true;
                        });
                        await Authentication.signOut();
                        setState(() {
                          _isSigningOut = false;
                        });
                        Get.off(
                          () => SignInScreen(),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
