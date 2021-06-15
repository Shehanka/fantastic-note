class Note {
  String _id;
  String _title;
  String _body;

  Note(this._id, this._title, this._body);

  Note.map(dynamic note) {
    this._id = note['id'];
    this._title = note['title'];
    this._body = note['body'];
  }

  String get id => _id;
  String get title => _title;
  String get body => _body;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['title'] = _title;
    map['body'] = _body;

    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._body = map['body'];
  }
}
