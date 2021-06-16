import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/models/user.dart';
import 'package:fantastic_note/services/custom/user_service.dart';
import 'package:flutter/material.dart';

class UserListScreen extends StatefulWidget {
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late List<User?> _usersList;
  late UserService _userService;
  late StreamSubscription<QuerySnapshot> _userSubscription;

  @override
  void initState() {
    super.initState();

    _usersList = [];
    _userService = UserService();
    _userSubscription.cancel();
    _userSubscription = _userService.getAll().listen((QuerySnapshot snapshot) {
      final List<User?> users = snapshot.docs
          .map((documentSnapshot) => documentSnapshot.data() as User?)
          .toList();

      setState(() {
        _usersList = users;
      });
    });
  }

  @override
  void dispose() {
    _userSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Card makeCard(User? user) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.deepPurpleAccent),
            child: buildTilesList(user),
          ),
        );

    final userListBody = Container(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _usersList.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(_usersList[index]);
        },
      ),
    );
    return Scaffold(
      body: userListBody,
    );
  }

  buildTilesList(User? user) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white30))),
          child: Text(
            "leisureActivity.type",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          user!.firstName,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.alarm, color: Colors.white, size: 30.0),
        onTap: () {},
      );
}
