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

  Stream<QuerySnapshot> getAll({int? offset, int? limit}) {
    Stream<QuerySnapshot> snapshots = usersCollection.snapshots();

    if (offset != null) snapshots = snapshots.skip(offset);

    if (limit != null) snapshots = snapshots.take(limit);

    return snapshots;
  }

  Future<DocumentSnapshot> getById(String id) {
    return usersCollection.doc(id).get();
  }

  Future<dynamic> deleteById(String id) {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(usersCollection.doc(id));

      tx.delete(ds.reference);
      return {'deleted': true};
    };

    return FirebaseFirestore.instance
        .runTransaction(deleteTransaction)
        .then((result) => result['deleted'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }
}
