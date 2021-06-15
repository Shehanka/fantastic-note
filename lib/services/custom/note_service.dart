import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/models/note.dart';

final CollectionReference notesCollection =
    FirebaseFirestore.instance.collection("notes");

class NoteService {
  Future<Note> create(Note note) {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(notesCollection.doc());

      final Map<String, dynamic> data = note.toMap();

      tx.set(ds.reference, data);

      return data;
    };

    return FirebaseFirestore.instance
        .runTransaction(createTransaction)
        .then((mapData) => Note.fromMap(mapData))
        .catchError((e) {
      print('error: $e');
      return null;
    });
  }

  Stream<QuerySnapshot> getAll({required int offset, required int limit}) {
    Stream<QuerySnapshot> snapshots = notesCollection.snapshots();

    snapshots = snapshots.skip(offset);

    snapshots = snapshots.take(limit);

    return snapshots;
  }

  Future<DocumentSnapshot> getById(String id) {
    return notesCollection.doc(id).get();
  }
}
