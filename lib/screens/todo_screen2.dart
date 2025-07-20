import 'package:firebasetodo/models/todo_model.dart';
import 'package:firebasetodo/services/firestore_service.dart';
import 'package:flutter/material.dart';

class TodoScreen2 extends StatefulWidget {
  const TodoScreen2({super.key});

  @override
  State<TodoScreen2> createState() => _TodoScreen2State();
}

class _TodoScreen2State extends State<TodoScreen2> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController editingController = TextEditingController();

  void addTodo() {
    final todoText = editingController.text.trim();
    if (todoText.isNotEmpty) {
      final todo = TodoModel(title: todoText);
      firestoreService.addTodo(todo);
      editingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Todo App")),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: editingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Add a new todo",
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(onPressed: addTodo, child: Text("Add")),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<TodoModel>>(
              stream: firestoreService.getTodos(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<TodoModel>> snapshot,
              ) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final todos = snapshot.data;

                return ListView.builder(
                  itemCount: todos?.length ?? 0,
                  itemBuilder: (context, index) {
                    final todo = todos![index];
                    return ListTile(
                      title: Text(todo.title),
                      trailing: IconButton(
                        onPressed: () {
                          firestoreService.deleteTodo(todo.id!);
                        },
                        icon: Icon(Icons.delete),
                      ),
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          todo.isCompleted = true;
                          firestoreService.updateTodo(todo);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
