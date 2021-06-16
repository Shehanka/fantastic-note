import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantastic_note/models/collection.dart';
import 'package:fantastic_note/models/note.dart';
import 'package:fantastic_note/models/todo.dart';

final CollectionReference notesCollection =
    FirebaseFirestore.instance.collection("notes");

final CollectionReference noteCollectionsCollection =
    FirebaseFirestore.instance.collection("notecollections");

class NoteService {
  Future<Note> createNote(
      String title, String description, String collection, String primaryUser) {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(notesCollection.doc());
      Note note = new Note(ds.id, title, description, collection, primaryUser);
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

  Future<NoteCollection> createCollection(String name, String userId) {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(noteCollectionsCollection.doc());
      NoteCollection collection = new NoteCollection(ds.id, name, userId);
      final Map<String, dynamic> data = collection.toMap();
      tx.set(ds.reference, data);
      return data;
    };

    return FirebaseFirestore.instance
        .runTransaction(createTransaction)
        .then((mapData) => NoteCollection.fromMap(mapData))
        .catchError((e) {
      print('error: $e');
      return null;
    });
  }

  Future<Todo> createToDo(String name, String noteId) {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(notesCollection.doc(noteId).collection('todo').doc());
      Todo todo = new Todo(ds.id, name, false);
      final Map<String, dynamic> data = todo.toMap();
      tx.set(ds.reference, data);
      return data;
    };

    return FirebaseFirestore.instance
        .runTransaction(createTransaction)
        .then((mapData) => Todo.fromMap(mapData))
        .catchError((e) {
      print('error: $e');
      return null;
    });
  }

  Future<dynamic> updateTodo(Todo todo, String noteId) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx
          .get(notesCollection.doc(noteId).collection('todo').doc(todo.id));
      await tx.update(ds.reference, todo.toMap());
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

  Future<dynamic> updateNote(Note note) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(notesCollection.doc(note.id));
      await tx.update(ds.reference, note.toMap());
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

  Future<dynamic> updateCollection(NoteCollection collection) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(noteCollectionsCollection.doc(collection.id));
      await tx.update(ds.reference, collection.toMap());
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
    Stream<QuerySnapshot> snapshots = notesCollection
        .where('collection', isEqualTo: collectionId)
        .snapshots();

    if (offset != null) snapshots = snapshots.skip(offset);

    if (limit != null) snapshots = snapshots.take(limit);

    return snapshots;
  }

  Stream<QuerySnapshot> getNoteToDoList(String noteId,
      {int? offset, int? limit}) {
    Stream<QuerySnapshot> snapshots =
        notesCollection.doc(noteId).collection("todo").snapshots();

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

  Future<dynamic> deleteCollection(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(noteCollectionsCollection.doc(id));

      await tx.delete(ds.reference);
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

  Future<dynamic> deleteNote(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(notesCollection.doc(id));

      await tx.delete(ds.reference);
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

  Future<dynamic> deleteTodo(String id, String note) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds =
          await tx.get(notesCollection.doc(note).collection('todo').doc(id));
      await tx.delete(ds.reference);
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
