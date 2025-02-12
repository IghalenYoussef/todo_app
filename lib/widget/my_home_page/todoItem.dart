import 'package:flutter/material.dart';

import '../../models/todo.dart';

class TodoItem extends StatelessWidget {
  TodoItem({super.key, required this.todo, required this.onTap});

  Todo todo;
  VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.name),
      subtitle: Text(todo.description ?? ""),
      onTap: onTap,
      trailing: todo.done ? Icon(Icons.check_circle, color: Colors.green,) : Icon(Icons.check_circle_outline, color: Colors.redAccent,),
    );
  }
}
