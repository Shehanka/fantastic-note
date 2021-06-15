class User {
  late String _id;
  late String _firstName;
  late String _lastName;
  late String _uid;

  User(this._id, this._firstName, this._lastName, this._uid);

  User.map(dynamic user) {
    this._id = user['id'];
    this._firstName = user['firstName'];
    this._lastName = user['lastName'];
    this._uid = user['uid'];
  }

  String get id => _id;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get uid => _uid;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['id'] = _id;
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['uid'] = _uid;

    return map;
  }

  User.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._firstName = map['firstName'];
    this._lastName = map['lastName'];
    this._uid = map['uid'];
  }
}
