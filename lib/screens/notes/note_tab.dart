import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/models/collection.dart';
import 'package:fantastic_note/models/note.dart';
import 'package:fantastic_note/services/custom/note_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotesTab extends StatefulWidget {
  NotesTab(this.collection, {Key? key});
  final NoteCollection collection;

  @override
  _NotesTabState createState() => _NotesTabState();
}

class _NotesTabState extends State<NotesTab> {
  late List<Note> noteList;
  NoteService noteService = NoteService();
  late StreamSubscription<QuerySnapshot> noteSubscription;

  @override
  void initState() {
    super.initState();

    noteList = [];
    noteSubscription = noteService
        .getNotesByCollection(widget.collection.id)
        .listen((QuerySnapshot snapshot) {
      List<Note> notes = snapshot.docs
          .map((d) => Note.fromMap(d.data() as Map<String, dynamic>))
          .toList();
      setState(() {
        print(notes);
        noteList = notes;
      });
    });
  }

  @override
  void dispose() {
    noteSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Card makeCard(Note note) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.deepPurpleAccent),
            child: buildTilesList(note),
          ),
        );

    final notesTabBody = noteList.isNotEmpty
        ? Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: noteList.length,
              itemBuilder: (BuildContext context, int index) {
                return makeCard(noteList[index]);
              },
            ),
          )
        : Container(
            child: Center(child: Text('Notes are not available!!')),
          );

    return Scaffold(backgroundColor: Colors.white10, body: notesTabBody);
  }

  buildTilesList(Note note) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white30))),
          child: Text(
            note.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          note.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
}
