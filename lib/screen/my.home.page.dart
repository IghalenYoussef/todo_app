import 'package:flutter/material.dart';
import 'package:test1/service/todoService.dart';
import 'package:test1/widget/my_home_page/todoItem.dart';

import '../models/todo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TodoService _todoService = TodoService();

  late List<Todo> todos = [];

  void _showAddTodoDialog(BuildContext context) {
    final TextEditingController todoNameController = TextEditingController();
    final TextEditingController todoDescriptionController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Aggiungi Todo"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: todoNameController,
                  decoration: InputDecoration(
                      labelText: "Todo name", border: OutlineInputBorder()),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: todoDescriptionController,
                  decoration: InputDecoration(
                      labelText: "Todo description",
                      border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  final String name = todoNameController.text;
                  final String description = todoDescriptionController.text;

                  if (name.isNotEmpty && description.isNotEmpty) {
                    int id = todos.last.id;
                    ++id;
                    Todo newTodo = Todo(
                        id: id,
                        name: name,
                        description: description,
                        done: false);
                    try {
                      Todo createTodo = await _todoService.createTodo(newTodo);
                      setState(() {
                        todos.add(createTodo);
                      });
                      Navigator.of(context).pop();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Error to create: $e"),
                      ));
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("TextField empty")));
                  }
                },
                child: Text("Add Todo")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel")),
          ],
        );
      },
    );
  }

  void _showUpdateTodoDialog(BuildContext context, Todo todo, int index) {
    TextEditingController todoNameController =
        TextEditingController(text: todo.name);
    TextEditingController todoDescriptionController =
        TextEditingController(text: todo.description);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Aggiorna il Todo"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: todoNameController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: todoDescriptionController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    final name = todoNameController.text;
                    final description = todoDescriptionController.text;

                    if (name.isNotEmpty && description.isNotEmpty) {
                      todo.name = name;
                      todo.description = description;

                      try {
                        await _todoService.update(todo);
                        setState(() {});
                        Navigator.of(context).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error to update: $e")));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("TextField empty")));
                    }
                  },
                  child: Text("Update Todo")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () => _showAddTodoDialog(context),
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder<List<Todo>>(
          future: _todoService.fetchTodos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text("Todos Not Found"),
              );
            }

            todos = snapshot.data!;

            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  Todo todo = todos[index];
                  return Dismissible(
                    key: Key(todo.id.toString()),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) async {
                      try {
                        await _todoService.deleteTodo(todo.id);
                        setState(() {
                          todos.removeAt(index);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("$todo dismissed"),
                            backgroundColor: Colors.redAccent));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error to delete: $e")),
                        );
                      }
                    },
                    child: Card(
                      elevation: 1,
                      child: TodoItem(
                        todo: todo,
                        onTap: () =>
                            _showUpdateTodoDialog(context, todo, index),
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
