import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/components/delete_dialog.dart';
import 'package:fantastic_note/components/rounded_input_field.dart';
import 'package:fantastic_note/models/collection.dart';
import 'package:fantastic_note/models/note.dart';
import 'package:fantastic_note/screens/notes/note_details.dart';
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
            decoration: BoxDecoration(color: Colors.deepPurpleAccent[100]),
            child: buildTilesList(note),
          ),
        );

    final notesTabBody = noteList != []
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
            child: Center(
                child: Text('Collection Is Empty !',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w600))),
          );

    return Scaffold(
      backgroundColor: Colors.white10,
      body: notesTabBody,
      floatingActionButton: FloatingActionButton(
          onPressed: () => {_createNewNote(context, widget.collection)},
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.deepPurpleAccent),
    );
  }

  buildTilesList(Note note) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          note.title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: Wrap(
          spacing: 5,
          children: <Widget>[
            FlatButton(
                onPressed: () => {_editNote(context, note, widget.collection)},
                child: Icon(
                  Icons.edit,
                  color: Colors.yellowAccent,
                  size: 25,
                )),
            FlatButton(
                onPressed: () => {showDeleteConfirmationDialog(context, note)},
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 25,
                )), // icon-1
          ],
        ),
        onTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NoteDetailScreen(note)))
        },
      );

  void _createNewNote(BuildContext context, NoteCollection collection) async {
    showDialog(
        context: context,
        builder: (_) {
          return FantasticDialog(
            note: new Note("", "", "", "", ""),
            collection: collection,
          );
        });
  }

  void _editNote(
      BuildContext context, Note note, NoteCollection collection) async {
    showDialog(
        context: context,
        builder: (_) {
          return FantasticDialog(
            note: note,
            collection: collection,
          );
        });
  }
}

void showDeleteConfirmationDialog(BuildContext context, Note note) {
  if (note.id != null) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DeleteDialogBox(
            title: 'Are you sure?',
            description: note.title + ' note will be permanently deleted!',
            confirmation: true,
            confirmationAction: () {
              NoteService _noteService = NoteService();
              Future<dynamic> isDeleted = _noteService.deleteNote(note.id);
              if (isDeleted != null) {
                Navigator.pop(context);
              } else {
                print('Note Delete Failed');
              }
            },
          );
        });
  } else {
    // showDialog<void>(
    //     context: context, child: Text('Something went wrong'));
  }
}

class FantasticDialog extends StatefulWidget {
  FantasticDialog({Key? key, required this.note, required this.collection});
  final Note note;
  final NoteCollection collection;
  _FantasticDialogState createState() => _FantasticDialogState();
}

class _FantasticDialogState extends State<FantasticDialog> {
  final _formKeyAddTodo = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  NoteService _noteService = NoteService();
  @override
  void initState() {
    if (widget.note.id != "") {
      titleController.text = widget.note.title;
      descriptionController.text = widget.note.description;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: widget.note.id == ""
          ? Text('Create Note',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepPurple))
          : Text('Update Note',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepPurple)),
      content: Form(
        key: _formKeyAddTodo,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RoundedInputField(
              controller: titleController,
              hintText: 'Note Title',
              onChanged: (value) {},
            ),
            SizedBox(height: 15),
            RoundedInputField(
              controller: descriptionController,
              hintText: 'Note Description',
              onChanged: (value) {},
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  elevation: 10,
                  color: Colors.deepPurpleAccent,
                  textColor: Colors.white,
                  child: Text("Save"),
                  onPressed: () {
                    if (_formKeyAddTodo.currentState!.validate()) {
                      // Adding to DB
                      if (widget.note.id == "") {
                        Future<Note> isAdded = _noteService.createNote(
                            titleController.text,
                            descriptionController.text,
                            widget.collection.id,
                            "1Cp5BSg6QlMhUM8DvJQU2fuvSHU2");
                        if (isAdded != null) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      } else {
                        Note newNote = Note(
                            widget.note.id,
                            titleController.text,
                            descriptionController.text,
                            widget.collection.id,
                            "1Cp5BSg6QlMhUM8DvJQU2fuvSHU2");

                        Future<dynamic> isUpdated =
                            _noteService.updateNote(newNote);
                        if (isUpdated != null) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                ),
                SizedBox(width: 10),
                RaisedButton(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
