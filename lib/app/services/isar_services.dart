import 'package:dark_todo/app/data/schema.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../main.dart';

class IsarServices extends ChangeNotifier {
  List<Tasks> tasks = List.empty();
  List<Todos> todos = List.empty();

  createTask(title, desc, color) async {
    final taskCreate = Tasks(
      title: title,
      description: desc,
      taskCreate: DateTime.now(),
      taskColor: color,
    );

    await isar.writeTxn(() async {
      await isar.tasks.put(taskCreate);
    });
    notifyListeners();
  }

  Future<List<Tasks>> getTask() async {
    await isar.txn(() async {
      tasks = await isar.tasks.where().findAll();
    });
    notifyListeners();
    return tasks;
  }
}
