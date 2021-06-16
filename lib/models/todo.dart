class Todo {
  late String _id;
  late String _name;
  late bool _completed;

  Todo(this._id, this._name, this._completed);

  Todo.map(dynamic note) {
    this._id = note['id'];
    this._name = note['name'];
    this._completed = note['completed'];
  }

  String get id => _id;
  String get name => _name;
  bool get completed => _completed;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['name'] = _name;
    map['completed'] = _completed;

    return map;
  }

  Todo.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._completed = map['completed'];
  }
}
