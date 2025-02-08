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

}