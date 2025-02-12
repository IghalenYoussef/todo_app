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

  List<Todo> todoList = [
    Todo(id: 1, name: "Pippo", description: "Sono Pippo!"),
    Todo(id: 2, name: "Pluto"),
    Todo(id: 3, name: "Paperino"),
  ];

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
                onPressed: () {
                  final String name = todoNameController.text;
                  final String description = todoDescriptionController.text;

                  if (name.isNotEmpty && description.isNotEmpty) {
                    int id = todoList.length;
                    ++id;
                    Todo newTodo =
                        Todo(id: id, name: name, description: description);
                    setState(() {
                      todoList.add(newTodo);
                    });
                    Navigator.of(context).pop();
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

            List<Todo> todos = snapshot.data!;

            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  Todo todo = todos[index];
                  final item = todos[index];
                  return Dismissible(
                    key: Key(item.id.toString()),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        todos.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$item dismissed")));
                    },
                    child: Card(
                      elevation: 1,
                      child: TodoItem(
                          todo: todo,
                          onTap: () {
                            setState(() {
                              todo.done = !todo.done;
                            });
                          }),
                    ),
                  );
                });
          }),
      /*floatingActionButton: FloatingActionButton(
        onPressed:() => _showAddTodoDialog(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/
    );
  }
}
