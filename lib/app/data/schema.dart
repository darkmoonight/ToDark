import 'package:isar/isar.dart';

part 'schema.g.dart';

@collection
class Tasks {
  Id id;
  String title;
  String description;
  int taskColor;
  bool archive;

  @Backlink(to: 'task')
  final todos = IsarLinks<Todos>();

  Tasks({
    this.id = Isar.autoIncrement,
    required this.title,
    this.description = '',
    this.archive = false,
    required this.taskColor,
  });

  Tasks.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'] ?? '',
        taskColor = json['taskColor'],
        archive = json['archive'] ?? false;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': title,
        'description': description,
        'todoCompletedTime': taskColor,
        'done': archive,
      };
}

@collection
class Todos {
  Id id;
  String name;
  String description;
  DateTime? todoCompletedTime;
  bool done;

  final task = IsarLink<Tasks>();

  Todos({
    this.id = Isar.autoIncrement,
    required this.name,
    this.description = '',
    this.todoCompletedTime,
    this.done = false,
  });

  Todos.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'] ?? '',
        todoCompletedTime = json['todoCompletedTime'],
        done = json['done'] ?? false;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'todoCompletedTime': todoCompletedTime,
        'done': done,
      };
}

@collection
class Settings {
  Id id = Isar.autoIncrement;
  bool onboard = false;
  bool? theme;
}
