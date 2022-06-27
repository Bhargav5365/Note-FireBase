import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/snackbar.dart';
import 'note_modal.dart';

class Database {
  static User? user = FirebaseAuth.instance.currentUser;

  static void updateNoteRef(String uid) {
    notesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notes')
        .withConverter<Note>(
          fromFirestore: (snapshot, _) => Note.fromJson(snapshot.data()!),
          toFirestore: (note, _) => note.toJson(),
        );
  }

  static var notesRef = FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('notes')
      .withConverter<Note>(
        fromFirestore: (snapshot, _) => Note.fromJson(snapshot.data()!),
        toFirestore: (note, _) => note.toJson(),
      );

  static Stream<QuerySnapshot<Note>> notes = notesRef.snapshots();

  static Future<void> addNote(Note data) {
    return notesRef
        .add(data)
        .then((value) => CustomSnackBar.show(
              'Note Added',
              Icons.check,
            ))
        .catchError((e) => print('Failed to add note: $e'));
  }

  static Future<void> deleteNoteById(String documentId) {
    return notesRef
        .doc(documentId)
        .delete()
        .then((value) => print('Note deleted'))
        .catchError((e) => print('Failed to delete note $e'));
  }

  static Future<void> updateNoteById(String documentId, Note note) {
    return notesRef
        .doc(documentId)
        .update({'title': note.title, 'dateTime': note.dateTime})
        .then((value) => CustomSnackBar.show(
              'Note Updated',
              Icons.check,
            ))
        .catchError((e) => print('Failed to update note: $e'));
  }
}
