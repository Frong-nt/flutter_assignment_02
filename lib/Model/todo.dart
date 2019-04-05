// To parse this JSON data, do
//
//     final todo = todoFromJson(jsonString);

import 'dart:convert';

Todo todoFromJson(String str) {
    final jsonData = json.decode(str);
    return Todo.fromMap(jsonData);
}

String todoToJson(Todo data) {
    final dyn = data.toMap();
    return json.encode(dyn);
}

class Todo {
    int id;
    String todo;
    int status;

    Todo({
        this.id,
        this.todo,
        this.status,
    });

    Todo.emyty();

    factory Todo.fromMap(Map<String, dynamic> json) => new Todo(
        id: json["id"],
        todo: json["todo"],
        status: json["status"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "todo": todo,
        "status": status,
    };

    @override
  String toString() {
    return todo;
  }
}
