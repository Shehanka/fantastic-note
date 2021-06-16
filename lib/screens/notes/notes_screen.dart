import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/models/collection.dart';
import 'package:fantastic_note/screens/notes/note_tab.dart';
import 'package:fantastic_note/services/custom/note_service.dart';
import 'package:flutter/material.dart';

class NotesScreen extends StatefulWidget {
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with TickerProviderStateMixin {
  late List<NoteCollection> _noteCollectionList;
  NoteService _noteService = NoteService();
  late StreamSubscription<QuerySnapshot> noteSubsciption;
  late TabController _collectionTabController;

  @override
  void initState() {
    super.initState();
    _noteCollectionList = [];
    noteSubsciption = _noteService
        .getUserNoteCollections("1Cp5BSg6QlMhUM8DvJQU2fuvSHU2")
        .listen((QuerySnapshot snapshot) {
      List<NoteCollection> noteCollections = snapshot.docs
          .map((d) => NoteCollection.fromMap(d.data() as Map<String, dynamic>))
          .toList();
      setState(() {
        this._noteCollectionList = noteCollections;
        _collectionTabController =
            new TabController(vsync: this, length: _noteCollectionList.length);
      });
    });
  }

  @override
  void dispose() {
    _collectionTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: new AppBar(
        title: new Text("Notes"),
        bottom: TabBar(
          controller: _collectionTabController,
          isScrollable: true,
          tabs: _noteCollectionList
              .map((note) => Tab(
                    text: note.name,
                  ))
              .toList(),
        ),
      ),
      body: TabBarView(
        key: Key(Random().nextDouble().toString()),
        controller: _collectionTabController,
        children:
            _noteCollectionList.map((noteCol) => NotesTab(noteCol)).toList(),
      ),
    );
  }
}
