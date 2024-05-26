import 'package:isar/isar.dart';

part 'schema.g.dart';

@collection
class Settings {
  Id id = Isar.autoIncrement;
  bool onboard = false;
  String? theme = 'system';
  String timeformat = '24';
  bool materialColor = true;
  bool amoledTheme = false;
  bool? isImage = true;
  String? language;
  String firstDay = 'monday';
}

@collection
class Tasks {
  Id id;
  String title;
  String description;
  int taskColor;
  bool archive;
  int? index;

  @Backlink(to: 'task')
  final todos = IsarLinks<Todos>();

  Tasks({
    this.id = Isar.autoIncrement,
    required this.title,
    this.description = '',
    this.archive = false,
    required this.taskColor,
    this.index,
  });
}

@collection
class Todos {
  Id id;
  String name;
  String description;
  DateTime? todoCompletedTime;
  bool done;
  bool fix;

  final task = IsarLink<Tasks>();

  Todos({
    this.id = Isar.autoIncrement,
    required this.name,
    this.description = '',
    this.todoCompletedTime,
    this.done = false,
    this.fix = false,
  });
}
