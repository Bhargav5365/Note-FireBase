import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../utils/database_helper.dart';
import '../utils/note_modal.dart';

class CreateNote extends StatelessWidget {
  final DocumentSnapshot<Note>? document;
  CreateNote({this.document, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text = "";
    text = document == null ? "" : document!.data()!.title;
    TextEditingController textEditingController =
        new TextEditingController(text: text)
          ..selection = TextSelection.collapsed(offset: text.length);

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back),
              ),
              Padding(
                padding: EdgeInsets.only(left: 75),
                child: document == null
                    ? Text('Create a New Note',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        ))
                    : Text('Update note',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 25,
                        )),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 11,
              ),
              child: TextField(
                controller: textEditingController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                cursorColor: Colors.black87,
                decoration: InputDecoration(
                  hintText: 'What do you want to save today?',
                  hintStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                    fontWeight: FontWeight.w400,
                  ),
                  counterText: '',
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                maxLength: 100,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                scrollPhysics: NeverScrollableScrollPhysics(),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  color: Colors.grey[200],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.times),
                    color: Colors.black,
                    iconSize: 26,
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Card(
                  color: Colors.grey[200],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.check),
                    color: Colors.black,
                    iconSize: 26,
                    onPressed: () {
                      Timestamp myTimeStamp =
                          Timestamp.fromDate(DateTime.now());
                      if (document == null) {
                        Database.addNote(
                          Note(
                              title: textEditingController.text,
                              name: FirebaseAuth
                                  .instance.currentUser!.displayName!,
                              uid: Database.user!.uid,
                              dateTime: myTimeStamp),
                        );
                      } else {
                        Database.updateNoteById(
                          document!.id,
                          Note(
                            title: textEditingController.text,
                            name:
                                FirebaseAuth.instance.currentUser!.displayName!,
                            dateTime: myTimeStamp,
                          ),
                        );
                      }
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
            ),
          ],
        ),
      ),
    );
  }
}
