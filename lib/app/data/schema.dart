import 'package:isar/isar.dart';

part 'schema.g.dart';

@collection
class Tasks {
  Id id;
  String title;
  String description;
  DateTime taskCreate;
  int taskColor;

  @Backlink(to: 'task')
  final todos = IsarLinks<Todos>();

  Tasks({
    this.id = Isar.autoIncrement,
    required this.title,
    this.description = '',
    required this.taskCreate,
    required this.taskColor,
  });
}

@collection
class Todos {
  Id id;
  String name;
  String description;
  DateTime todoTimeCompleted;
  bool done;

  final task = IsarLink<Tasks>();

  Todos({
    this.id = Isar.autoIncrement,
    required this.name,
    this.description = '',
    required this.todoTimeCompleted,
    this.done = false,
  });
}

@collection
class Settings {
  Id id = Isar.autoIncrement;
  bool onboard = false;
}
