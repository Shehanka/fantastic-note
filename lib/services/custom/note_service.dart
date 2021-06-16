import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/models/note.dart';
import 'package:fantastic_note/models/todo.dart';

final CollectionReference notesCollection =
    FirebaseFirestore.instance.collection("notes");

final CollectionReference noteCollectionsCollection =
    FirebaseFirestore.instance.collection("notecollections");

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

  Future<dynamic> updateTodoList(String noteId, List<Todo> todoList) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(notesCollection.doc(noteId));
      await tx.update(ds.reference, {"todo": todoList});
      return {'updated': true};
    };

    return FirebaseFirestore.instance
        .runTransaction(updateTransaction)
        .then((result) => result['updated'])
        .catchError((error) {
      print('error: $error');
      return false;
    });
  }

  Stream<QuerySnapshot> getAll({int? offset, int? limit}) {
    Stream<QuerySnapshot> snapshots = notesCollection.snapshots();

    if (offset != null) snapshots = snapshots.skip(offset);

    if (limit != null) snapshots = snapshots.take(limit);

    return snapshots;
  }

  Stream<QuerySnapshot> getNotesByCollection(String collectionId,
      {int? offset, int? limit}) {
    print(collectionId);
    Stream<QuerySnapshot> snapshots = notesCollection
        .where('collection', isEqualTo: collectionId)
        .snapshots();

    if (offset != null) snapshots = snapshots.skip(offset);

    if (limit != null) snapshots = snapshots.take(limit);

    return snapshots;
  }

  Stream<QuerySnapshot> getUserNoteCollections(String userId,
      {int? offset, int? limit}) {
    Stream<QuerySnapshot> snapshots = noteCollectionsCollection
        .where('userId', isEqualTo: userId)
        .snapshots();

    if (offset != null) snapshots = snapshots.skip(offset);

    if (limit != null) snapshots = snapshots.take(limit);

    return snapshots;
  }

  Future<DocumentSnapshot> getById(String id) {
    return notesCollection.doc(id).get();
  }
}
