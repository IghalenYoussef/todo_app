import 'package:json_annotation/json_annotation.dart';

part 'todo.g.dart';

@JsonSerializable()
class Todo {

  int id;
  String name;
  String? description;
  bool done;

  Todo({
    required this.id,
    required this.name,
    this.description,
    this.done = false
});

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  Map<String, dynamic> toJson() => _$TodoToJson(this);
}