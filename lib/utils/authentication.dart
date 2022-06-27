import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../custom_widgets/snackbar.dart';
import '../screens/notes.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Get.off(
        () => MyNotes(user: user),
      );
    }
    return firebaseApp;
  }

  static Future<User?> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
        return user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          CustomSnackBar.show('ERROR_1', FontAwesomeIcons.exclamationTriangle);
        } else {
          CustomSnackBar.show(
            'Something went wrong, Try again',
            FontAwesomeIcons.exclamationTriangle,
          );
        }
      }
    }
  }

  static Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      CustomSnackBar.show(
        'SIGNOUT_ERROR',
        FontAwesomeIcons.exclamationTriangle,
      );
    }
  }
}
