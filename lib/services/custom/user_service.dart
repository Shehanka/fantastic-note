import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/models/user.dart';

final CollectionReference usersCollection =
    FirebaseFirestore.instance.collection("users");

class UserService {
  Future<User> create(User user) {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(usersCollection.doc());

      final Map<String, dynamic> data = user.toMap();

      tx.set(ds.reference, data);

      return data;
    };

    return FirebaseFirestore.instance
        .runTransaction(createTransaction)
        .then((value) => User.fromMap(value))
        .catchError((e) {
      print('error: $e');
      return null;
    });
  }
}
