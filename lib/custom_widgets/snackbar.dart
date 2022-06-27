import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  final String message;
  final IconData myIcon;

  const CustomSnackBar({
    required this.message,
    required this.myIcon,
  });

  static show(String message, IconData myIcon) {
    Get.rawSnackbar(
      icon: myIcon == FontAwesomeIcons.exclamationTriangle
          ? Icon(
              myIcon,
              color: Colors.amber,
            )
          : Card(
              color: myIcon == Icons.delete
                  ? Colors.transparent
                  : Color(0xFF9CE7A9),
              elevation: 0,
              shape: CircleBorder(),
              child: Icon(
                myIcon,
                color: myIcon == Icons.delete
                    ? Colors.redAccent
                    : Color(0xFF135121),
              ),
            ),
      shouldIconPulse: false,
      backgroundColor: Colors.white,
      messageText: Text(
        message,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ), // message
      mainButton: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text(
          'Close',
          style: TextStyle(
            color: Colors.grey.withOpacity(0.6),
            fontSize: 15,
          ),
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 13, horizontal: 14),
      borderRadius: 12,
      boxShadows: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 3.0,
        )
      ],
      duration: Duration(seconds: 5),
    );
  }
}
