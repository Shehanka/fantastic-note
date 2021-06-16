import 'package:fantastic_note/models/todo.dart';

class Note {
  late String _id;
  late String _title;
  late String _description;
  late String _collection;
  late String _primaryUser;
  //late List<String> _sharedUsers;

  Note(this._id, this._title, this._description, this._collection,
      this._primaryUser);

  Note.map(dynamic note) {
    this._id = note['id'];
    this._title = note['title'];
    this._description = note['description'];
    //this._sharedUsers = note['sharedUsers'];
    this._primaryUser = note['primaryUser'];
    this._collection = note['collection'];
  }

  String get id => _id;
  String get title => _title;
  String get description => _description;
  //List get sharedUsers => _sharedUsers;
  String get primaryUser => _primaryUser;
  String get collection => _collection;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['title'] = _title;
    map['description'] = _description;
    //map['sharedUsers'] = _sharedUsers;
    map['collection'] = _collection;
    map['primaryUser'] = _primaryUser;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    //this._sharedUsers = map['sharedUsers'];
    this._primaryUser = map['primaryUser'];
    this._collection = map['collection'];
  }
}
