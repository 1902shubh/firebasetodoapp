import 'package:firebasetodo/models/todo_model.dart';
import 'package:firebasetodo/services/database_service.dart';
import 'package:flutter/material.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController editingController = TextEditingController();

  void addTodo() {
    final todoText = editingController.text.trim();
    if (todoText.isNotEmpty) {
      final todo = TodoModel(title: todoText);
      databaseService.addTodo(todo);
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
              stream: databaseService.getTodos(),
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
                          databaseService.deleteTodo(todo.id!);
                        },
                        icon: Icon(Icons.delete),
                      ),
                      leading: Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          todo.isCompleted = true;
                          databaseService.updateTodo(todo);
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
