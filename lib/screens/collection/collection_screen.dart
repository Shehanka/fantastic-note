import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/components/delete_dialog.dart';
import 'package:fantastic_note/components/rounded_input_field.dart';
import 'package:fantastic_note/models/collection.dart';
import 'package:fantastic_note/services/custom/note_service.dart';
import 'package:flutter/material.dart';

class CollectionScreen extends StatefulWidget {
  _ColletionScreenState createState() => _ColletionScreenState();
}

class _ColletionScreenState extends State<CollectionScreen> {
  late List<NoteCollection> _noteCollectionList;
  NoteService _noteService = NoteService();

  @override
  void initState() {
    super.initState();
    _noteCollectionList = [];
    // ignore: cancel_subscriptions
    // ignore: unused_local_variable
    // ignore: cancel_subscriptions
    StreamSubscription<QuerySnapshot> noteSubsciption = _noteService
        .getUserNoteCollections("1Cp5BSg6QlMhUM8DvJQU2fuvSHU2")
        .listen((QuerySnapshot snapshot) {
      List<NoteCollection> noteCollections = snapshot.docs
          .map((d) => NoteCollection.fromMap(d.data() as Map<String, dynamic>))
          .toList();
      setState(() {
        this._noteCollectionList = noteCollections;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Card makeCard(NoteCollection collection) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.deepPurpleAccent[100]),
            child: buildTilesList(collection),
          ),
        );

    final notesTabBody = _noteCollectionList != []
        ? Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _noteCollectionList.length,
              itemBuilder: (BuildContext context, int index) {
                return makeCard(_noteCollectionList[index]);
              },
            ),
          )
        : Container(
            child: Center(
                child: Text('No Collections !',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w600))),
          );

    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Note Collections"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: notesTabBody,
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_createNewCollection(context)},
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
    );
  }

  buildTilesList(NoteCollection collection) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          collection.name,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        trailing: Wrap(
          spacing: 5,
          children: <Widget>[
            FlatButton(
                onPressed: () => {_editCollection(context, collection)},
                child: Icon(
                  Icons.edit,
                  color: Colors.yellowAccent,
                  size: 25,
                )),
            FlatButton(
                onPressed: () =>
                    {showDeleteConfirmationDialog(context, collection)},
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                  size: 25,
                )), // icon-1
          ],
        ),
      );

  void _createNewCollection(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return FantasticDialog(
            collection: new NoteCollection("", "", ""),
          );
        });
  }

  void _editCollection(BuildContext context, NoteCollection collection) async {
    showDialog(
        context: context,
        builder: (_) {
          return FantasticDialog(
            collection: collection,
          );
        });
  }
}

void showDeleteConfirmationDialog(
    BuildContext context, NoteCollection collection) {
  if (collection.id != null) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DeleteDialogBox(
            title: 'Are you sure?',
            description:
                collection.name + ' collection will be permanently deleted!',
            confirmation: true,
            confirmationAction: () {
              NoteService _noteService = NoteService();
              Future<dynamic> isDeleted =
                  _noteService.deleteCollection(collection.id);
              if (isDeleted != null) {
                Navigator.pop(context);
              } else {
                print('Collection Delete Failed');
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
  FantasticDialog({Key? key, required this.collection});
  final NoteCollection collection;
  _FantasticDialogState createState() => _FantasticDialogState();
}

class _FantasticDialogState extends State<FantasticDialog> {
  final _formKeyAddTodo = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  NoteService _noteService = NoteService();
  @override
  void initState() {
    if (widget.collection.id != "") {
      nameController.text = widget.collection.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: widget.collection.id == ""
          ? Text('Create Collection',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepPurple))
          : Text('Update Collection',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepPurple)),
      content: Form(
        key: _formKeyAddTodo,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RoundedInputField(
              controller: nameController,
              hintText: 'Collection Name',
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
                      if (widget.collection.id == "") {
                        Future<NoteCollection> isAdded =
                            _noteService.createCollection(nameController.text,
                                "1Cp5BSg6QlMhUM8DvJQU2fuvSHU2");
                        if (isAdded != null) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      } else {
                        NoteCollection newNoteCollection = NoteCollection(
                            widget.collection.id,
                            nameController.text,
                            "1Cp5BSg6QlMhUM8DvJQU2fuvSHU2");

                        Future<dynamic> isUpdated =
                            _noteService.updateCollection(newNoteCollection);
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
