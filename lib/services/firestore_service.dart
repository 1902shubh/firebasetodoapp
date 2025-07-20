import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebasetodo/models/todo_model.dart';

class FirestoreService {
  final CollectionReference collectionReference = FirebaseFirestore.instance
      .collection("todo");

  Stream<List<TodoModel>> getTodos() {
    return collectionReference.snapshots().map((snapshot) {
      return snapshot.docs.map((element) {
        return TodoModel.fromMap(element.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> addTodo(TodoModel todo) async {
    final todoRef = collectionReference.doc();
    final id = todoRef.id;
    todo.id = id;

    await todoRef.set(todo.toMap());
  }

  Future<void> updateTodo(TodoModel todo) async {
    await collectionReference.doc(todo.id).update(todo.toMap());
  }

  Future<void> deleteTodo(String id) async {
    await collectionReference.doc(id).delete();
  }
}
