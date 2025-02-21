import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:test1/models/todo.dart';

class TodoService {
  final String baseUrl = 'http://192.168.1.3:3000/todo';

  Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }

  Future<Todo> fetchTodoById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }

  Future<Todo> createTodo(Todo todo) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(todo.toJson()));

    if (response.statusCode == 201) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }

  Future<Todo> update(Todo todo) async {
    final response = await http.put(Uri.parse('$baseUrl/${todo.id}'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(todo.toJson()));

    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }

  Future<void> deleteTodo(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }
}
