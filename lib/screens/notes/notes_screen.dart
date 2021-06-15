import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/models/note.dart';
import 'package:fantastic_note/services/custom/note_service.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late List<Note> _notesList;
  NoteService _noteService = NoteService();
  late StreamSubscription<QuerySnapshot> noteSubsciption;

  @override
  void initState() {
    super.initState();

    _notesList = [];
    noteSubsciption?.cancel();
    noteSubsciption = _noteService.getAll().listen((QuerySnapshot snapshot) {
      // final List<Note> notes =
      // snapshot.docs.map((d) => Note.fromMap(d.data())).toList();

      // setState(() {
      //   this._notesList = notes;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
