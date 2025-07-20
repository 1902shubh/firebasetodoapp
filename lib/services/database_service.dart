import 'package:firebase_database/firebase_database.dart';
import 'package:firebasetodo/models/todo_model.dart';

class DatabaseService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref(
    "todo",
  );

  Stream<List<TodoModel>> getTodos() {
    return databaseReference.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) return [];

      return data.entries.map((entry) {
        final todo = TodoModel.fromMap(Map<String, dynamic>.from(entry.value));
        return todo;
      }).toList();
    });
  }

  Future<void> addTodo(TodoModel todo) async {
    final todoRef = databaseReference.push();
    final id = todoRef.key;
    todo.id = id;

    await todoRef.set(todo.toMap());
  }

  Future<void> updateTodo(TodoModel todo) async {
    await databaseReference.child(todo.id!).update(todo.toMap());
  }

  Future<void> deleteTodo(String id) async {
    await databaseReference.child(id).remove();
  }
}
