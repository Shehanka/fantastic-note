import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/components/delete_dialog.dart';
import 'package:fantastic_note/components/rounded_input_field.dart';
import 'package:fantastic_note/models/collection.dart';
import 'package:fantastic_note/models/note.dart';
import 'package:fantastic_note/models/todo.dart';
import 'package:fantastic_note/screens/notes/note_tab.dart';
import 'package:fantastic_note/services/custom/note_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:line_icons/line_icons.dart';

class NoteDetailScreen extends StatefulWidget {
  NoteDetailScreen(this.note, {Key? key});
  final Note note;

  _NoteDetailScreenState createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen>
    with SingleTickerProviderStateMixin {
  late List<Todo> todoCollectionList;
  NoteService _noteService = NoteService();
  late StreamSubscription<QuerySnapshot> noteSubsciption;
  late TabController _collectionTabController;
  late ScrollController scrollController;
  bool dialVisible = true;

  @override
  void initState() {
    super.initState();
    todoCollectionList = [];
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });

    noteSubsciption = _noteService
        .getNoteToDoList(widget.note.id)
        .listen((QuerySnapshot snapshot) {
      List<Todo> todoCollections = snapshot.docs
          .map((d) => Todo.fromMap(d.data() as Map<String, dynamic>))
          .toList();
      setState(() {
        this.todoCollectionList = todoCollections;
      });
    });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  @override
  void dispose() {
    _collectionTabController.dispose();
    super.dispose();
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.add,
      activeIcon: Icons.remove,

      buttonSize: 56.0,
      visible: true,

      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.7,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Quick Access',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.white,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),

      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      gradientBoxShape: BoxShape.circle,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.deepPurple, Colors.purple],
      ),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.deepPurpleAccent,
          label: 'Add To Do',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => {_createNewTodo(context)},
        ),
        SpeedDialChild(
          child: Icon(Icons.share),
          backgroundColor: Colors.deepPurpleAccent,
          label: 'Share Note',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Card makeCard(Todo todo) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2.0, color: Colors.deepPurple)),
            child: buildTilesList(todo),
          ),
        );

    final todoListBody = todoCollectionList.isNotEmpty
        ? Container(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: todoCollectionList.length,
              itemBuilder: (BuildContext context, int index) {
                return makeCard(todoCollectionList[index]);
              },
            ),
          )
        : Container(
            child: Center(
                child: Text('Todo List Is Empty !',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.w600))),
          );

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.note.title),
          centerTitle: true,
        ),
        floatingActionButton: buildSpeedDial(),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 25, 10, 30),
              child: RichText(
                  text: TextSpan(
                      text: widget.note.description,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ))),
            ),
            todoListBody
          ],
        ));
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.deepPurple;
  }

  buildTilesList(Todo todo) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: todo.completed,
          onChanged: (bool? value) {
            Todo newTodo = Todo(todo.id, todo.name, value!);

            Future<dynamic> isUpdated =
                _noteService.updateTodo(newTodo, widget.note.id);
          },
        ),
        title: Text(
          todo.name,
          style: TextStyle(
              color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        trailing: Wrap(
          children: <Widget>[
            FlatButton(
                onPressed: () => {_editTodo(context, todo)},
                child: Icon(
                  Icons.edit,
                  color: Colors.deepPurple,
                  size: 20,
                )),
            FlatButton(
                onPressed: () => {
                      showDeleteConfirmationDialog(
                          context, todo, widget.note.id)
                    },
                child: Icon(
                  Icons.delete,
                  color: Colors.deepPurple,
                  size: 20,
                )), // icon-1
          ],
        ),
      );

  void _createNewTodo(BuildContext context) async {
    showDialog(
        context: context,
        builder: (_) {
          return FantasticDialog(
              todo: new Todo("", "", false), note: widget.note);
        });
  }

  void _editTodo(BuildContext context, Todo todo) async {
    showDialog(
        context: context,
        builder: (_) {
          return FantasticDialog(todo: todo, note: widget.note);
        });
  }
}

void showDeleteConfirmationDialog(
    BuildContext context, Todo todo, String noteId) {
  if (todo.id != null) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return DeleteDialogBox(
            title: 'Are you sure?',
            description: todo.name + ' To Do will be permanently deleted!',
            confirmation: true,
            confirmationAction: () {
              NoteService _noteService = NoteService();
              Future<dynamic> isDeleted =
                  _noteService.deleteTodo(todo.id, noteId);
              if (isDeleted != null) {
                Navigator.pop(context);
              } else {
                print('Todo Delete Failed');
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
  FantasticDialog({Key? key, required this.todo, required this.note});
  Note note;
  final Todo todo;
  _FantasticDialogState createState() => _FantasticDialogState();
}

class _FantasticDialogState extends State<FantasticDialog> {
  final _formKeyAddTodo = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  NoteService _noteService = NoteService();
  @override
  void initState() {
    if (widget.todo.id != "") {
      nameController.text = widget.todo.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: widget.todo.id == ""
          ? Text('Create Todo',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.deepPurple))
          : Text('Update Todo',
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
              hintText: 'Todo Name',
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
                      if (widget.todo.id == "") {
                        Future<Todo> isAdded = _noteService.createToDo(
                            nameController.text, widget.note.id);
                        if (isAdded != null) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      } else {
                        Todo newTodo = Todo(widget.todo.id, nameController.text,
                            widget.todo.completed);

                        Future<dynamic> isUpdated =
                            _noteService.updateTodo(newTodo, widget.note.id);
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
