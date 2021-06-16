class NoteCollection {
  late String _id;
  late String _name;
  late String _userId;

  NoteCollection(this._id, this._name, this._userId);

  NoteCollection.map(dynamic note) {
    this._id = note['id'];
    this._name = note['name'];
    this._userId = note['userId'];
  }

  String get id => _id;
  String get name => _name;
  String get userId => _userId;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['name'] = _name;
    map['userId'] = _userId;

    return map;
  }

  NoteCollection.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._userId = map['userId'];
  }
}
