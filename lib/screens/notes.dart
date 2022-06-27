import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:notefirebase/screens/user_info_screen.dart';

import '../custom_widgets/snackbar.dart';
import '../utils/database_helper.dart';
import '../utils/note_modal.dart';
import 'create_note.dart';

enum NoteQuery {
  titleAsc,
  titleDesc,
  dateAsc,
  dateDesc,
}

extension on Query<Note> {
  Query<Note> queryBy(NoteQuery query) {
    switch (query) {
      case NoteQuery.titleAsc:
      case NoteQuery.titleDesc:
        return orderBy('title', descending: query == NoteQuery.titleDesc);
      case NoteQuery.dateAsc:
      case NoteQuery.dateDesc:
        return orderBy('dateTime', descending: query == NoteQuery.dateDesc);
    }
  }
}

class MyNotes extends StatefulWidget {
  final User? _user;
  const MyNotes({Key? key, User? user})
      : _user = user,
        super(key: key);

  @override
  _MyNotesState createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  late Stream<QuerySnapshot<Note>> _notes;
  ValueNotifier<NoteQuery> _selectedItem =
      new ValueNotifier<NoteQuery>(NoteQuery.dateAsc);
  late Query<Note> _notesQuery;

  void _updateNotesQuery(NoteQuery query) {
    setState(() {
      Database.updateNoteRef(FirebaseAuth.instance.currentUser!.uid);
      _notesQuery = Database.notesRef.queryBy(query);
      _notes = _notesQuery.snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    _updateNotesQuery(NoteQuery.dateAsc);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 27,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.symmetric(
                  horizontal: 38,
                  vertical: 12,
                ),
                title: Text(
                  'Notes',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    size: 28,
                    color: Colors.black87,
                  ),
                  onPressed: () {
                    Get.to(
                      () => UserInfoScreen(user: widget._user),
                    );
                  },
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
          body: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<QuerySnapshot<Note>>(
                    stream: _notes,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Note>> snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Icon(
                            FontAwesomeIcons.exclamationTriangle,
                            size: 80,
                            color: Colors.blue,
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        );
                      } else if (snapshot.data!.docs.length == 0) {
                        return Center(
                          child: Text(
                            'EMPTY',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      } else {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: Key(snapshot.data!.docs[index].id),
                              background: Container(
                                alignment: AlignmentDirectional.centerEnd,
                                color: Colors.transparent,
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 0.0, 30.0, 0.0),
                                  child: Icon(
                                    Icons.delete,
                                    size: 32,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                Database.deleteNoteById(
                                    snapshot.data!.docs[index].id);
                                CustomSnackBar.show(
                                  'Note deleted',
                                  Icons.delete,
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        DocumentReference docRef = Database
                                            .notesRef
                                            .doc(snapshot.data!.docs[index].id);
                                        DocumentSnapshot<Note> docSnap =
                                            await docRef.get()
                                                as DocumentSnapshot<Note>;

                                        Get.to(
                                          () => CreateNote(document: docSnap),
                                        );
                                      },
                                      child: Container(
                                        height: 130,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(20),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 27, top: 15),
                                          child: Text(
                                            snapshot.data!.docs[index]
                                                .data()
                                                .title,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 17,
                                                color: Colors.black87),
                                            overflow: TextOverflow.fade,
                                            softWrap: false,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 190,
                                      bottom: 2,
                                      child: Row(
                                        children: [
                                          Card(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  '${DateFormat("d MMM y").format(snapshot.data!.docs[index].data().dateTime!.toDate())}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 8,
                                                      color: Colors.black87)),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Card(
                                            color:
                                                Colors.white.withOpacity(0.5),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  '${DateFormat("jm").format(snapshot.data!.docs[index].data().dateTime!.toDate())}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 8,
                                                      color: Colors.black87)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Get.to(
              () => CreateNote(),
            );
          },
          child: Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
