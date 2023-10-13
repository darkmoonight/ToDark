import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/notification.dart';
import 'package:todark/main.dart';

class TodoController extends GetxController {
  final tasks = <Tasks>[].obs;
  final todos = <Todos>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(isar.tasks.where().sortByIndex().findAllSync());
    todos.assignAll(isar.todos.where().findAllSync());
  }

  // Tasks
  Future<void> addTask(String title, String desc, Color myColor) async {
    List<Tasks> searchTask;
    searchTask = isar.tasks.filter().titleEqualTo(title).findAllSync();

    final taskCreate = Tasks(
      title: title,
      description: desc,
      taskColor: myColor.value,
    );

    if (searchTask.isEmpty) {
      isar.writeTxnSync(() {
        tasks.add(taskCreate);
        isar.tasks.putSync(taskCreate);
      });
      EasyLoading.showSuccess('createCategory'.tr,
          duration: const Duration(milliseconds: 500));
    } else {
      EasyLoading.showError('duplicateCategory'.tr,
          duration: const Duration(milliseconds: 500));
    }
  }

  Future<void> updateTask(
      Tasks task, String title, String desc, Color myColor) async {
    isar.writeTxnSync(() {
      task.title = title;
      task.description = desc;
      task.taskColor = myColor.value;
      isar.tasks.putSync(task);

      var newTask = task;
      int oldIdx = tasks.indexOf(task);
      tasks[oldIdx] = newTask;
      tasks.refresh();
      todos.refresh();
    });
    EasyLoading.showSuccess('editCategory'.tr,
        duration: const Duration(milliseconds: 500));
  }

  Future<void> deleteTask(List<Tasks> taskList) async {
    for (var task in taskList) {
      // Delete Notification
      List<Todos> getTodo;
      getTodo =
          isar.todos.filter().task((q) => q.idEqualTo(task.id)).findAllSync();

      for (var element in getTodo) {
        if (element.todoCompletedTime != null) {
          if (element.todoCompletedTime!.isAfter(DateTime.now())) {
            await flutterLocalNotificationsPlugin.cancel(element.id);
          }
        }
      }
      // Delete Todos
      isar.writeTxnSync(() {
        todos.removeWhere((todo) => todo.task.value == task);
        isar.todos.filter().task((q) => q.idEqualTo(task.id)).deleteAllSync();
      });
      // Delete Task
      isar.writeTxnSync(() {
        tasks.remove(task);
        isar.tasks.deleteSync(task.id);
      });
      EasyLoading.showSuccess('categoryDelete'.tr,
          duration: const Duration(milliseconds: 500));
    }
  }

  Future<void> archiveTask(List<Tasks> taskList) async {
    for (var task in taskList) {
      // Delete Notification
      List<Todos> getTodo;
      getTodo =
          isar.todos.filter().task((q) => q.idEqualTo(task.id)).findAllSync();

      for (var element in getTodo) {
        if (element.todoCompletedTime != null) {
          if (element.todoCompletedTime!.isAfter(DateTime.now())) {
            await flutterLocalNotificationsPlugin.cancel(element.id);
          }
        }
      }
      // Archive Task
      isar.writeTxnSync(() {
        task.archive = true;
        isar.tasks.putSync(task);

        tasks.refresh();
        todos.refresh();
      });
      EasyLoading.showSuccess('categoryArchive'.tr,
          duration: const Duration(milliseconds: 500));
    }
  }

  Future<void> noArchiveTask(List<Tasks> taskList) async {
    for (var task in taskList) {
      // Create Notification
      List<Todos> getTodo;
      getTodo =
          isar.todos.filter().task((q) => q.idEqualTo(task.id)).findAllSync();

      for (var element in getTodo) {
        if (element.todoCompletedTime != null) {
          if (element.todoCompletedTime!.isAfter(DateTime.now())) {
            NotificationShow().showNotification(
              element.id,
              element.name,
              element.description,
              element.todoCompletedTime,
            );
          }
        }
      }
      // No archive Task
      isar.writeTxnSync(() {
        task.archive = false;
        isar.tasks.putSync(task);

        tasks.refresh();
        todos.refresh();
      });
      EasyLoading.showSuccess('noCategoryArchive'.tr,
          duration: const Duration(milliseconds: 500));
    }
  }

  // Todos
  Future<void> addTodo(
      Tasks task, String title, String desc, String time) async {
    DateTime? date;
    if (time.isNotEmpty) {
      date = DateFormat.yMMMEd(locale.languageCode).add_Hm().parse(time);
    }
    List<Todos> getTodos;
    getTodos = isar.todos
        .filter()
        .nameEqualTo(title)
        .task((q) => q.idEqualTo(task.id))
        .todoCompletedTimeEqualTo(date)
        .findAllSync();

    final todosCreate = Todos(
      name: title,
      description: desc,
      todoCompletedTime: date,
    )..task.value = task;

    if (getTodos.isEmpty) {
      isar.writeTxnSync(() {
        todos.add(todosCreate);
        isar.todos.putSync(todosCreate);
        todosCreate.task.saveSync();
        if (time.isNotEmpty) {
          NotificationShow().showNotification(
            todosCreate.id,
            todosCreate.name,
            todosCreate.description,
            date,
          );
        }
      });
      EasyLoading.showSuccess('todoCreate'.tr,
          duration: const Duration(milliseconds: 500));
    } else {
      EasyLoading.showError('duplicateTodo'.tr,
          duration: const Duration(milliseconds: 500));
    }
  }

  Future<void> updateTodoCheck(Todos todo) async {
    isar.writeTxnSync(() => isar.todos.putSync(todo));
    todos.refresh();
  }

  Future<void> updateTodo(
      Todos todo, Tasks task, String title, String desc, String time) async {
    DateTime? date;
    if (time.isNotEmpty) {
      date = DateFormat.yMMMEd(locale.languageCode).add_Hm().parse(time);
    }
    isar.writeTxnSync(() {
      todo.name = title;
      todo.description = desc;
      todo.todoCompletedTime = date;
      todo.task.value = task;
      isar.todos.putSync(todo);
      todo.task.saveSync();

      var newTodo = todo;
      int oldIdx = todos.indexOf(todo);
      todos[oldIdx] = newTodo;
      todos.refresh();
    });
    if (time.isNotEmpty) {
      await flutterLocalNotificationsPlugin.cancel(todo.id);
      NotificationShow().showNotification(
        todo.id,
        todo.name,
        todo.description,
        date,
      );
    } else {
      await flutterLocalNotificationsPlugin.cancel(todo.id);
    }
    EasyLoading.showSuccess('updateTodo'.tr,
        duration: const Duration(milliseconds: 500));
  }

  Future<void> deleteTodo(List<Todos> todoList) async {
    for (var todo in todoList) {
      isar.writeTxnSync(() {
        todos.remove(todo);
        isar.todos.deleteSync(todo.id);
      });
      if (todo.todoCompletedTime != null) {
        await flutterLocalNotificationsPlugin.cancel(todo.id);
      }
      EasyLoading.showSuccess('todoDelete'.tr,
          duration: const Duration(milliseconds: 500));
    }
  }

  int createdAllTodos() {
    return todos.where((todo) => todo.task.value?.archive == false).length;
  }

  int completedAllTodos() {
    return todos
        .where((todo) => todo.task.value?.archive == false && todo.done == true)
        .length;
  }

  int createdAllTodosTask(Tasks task) {
    return todos.where((todo) => todo.task.value?.id == task.id).length;
  }

  int completedAllTodosTask(Tasks task) {
    return todos
        .where((todo) => todo.task.value?.id == task.id && todo.done == true)
        .length;
  }

  int countTotalTodosCalendar(DateTime date) {
    return todos
        .where((todo) =>
            todo.done == false &&
            todo.todoCompletedTime != null &&
            todo.task.value?.archive == false &&
            DateTime(date.year, date.month, date.day, 0, -1)
                .isBefore(todo.todoCompletedTime!) &&
            DateTime(date.year, date.month, date.day, 23, 60)
                .isAfter(todo.todoCompletedTime!))
        .length;
  }

  void backup() async {
    final dlPath = await FilePicker.platform.getDirectoryPath();

    if (dlPath == null) {
      EasyLoading.showInfo('errorPath'.tr);
      return;
    }

    try {
      final timeStamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

      final taskFileName = 'task_$timeStamp.json';
      final todoFileName = 'todo_$timeStamp.json';

      final fileTask = File('$dlPath/$taskFileName');
      final fileTodo = File('$dlPath/$todoFileName');

      final task = isar.tasks.where().exportJsonSync();
      final todo = isar.todos.where().exportJsonSync();

      await fileTask.writeAsString(jsonEncode(task));
      await fileTodo.writeAsString(jsonEncode(todo));
      EasyLoading.showSuccess('successBackup'.tr);
    } catch (e) {
      EasyLoading.showError('error'.tr);
      return Future.error(e);
    }
  }

  void restore() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      allowMultiple: true,
    );

    if (result == null) {
      EasyLoading.showInfo('errorPathRe'.tr);
      return;
    }

    bool taskSuccessShown = false;
    bool todoSuccessShown = false;

    for (final files in result.files) {
      final name = files.name.substring(0, 4);
      final file = File(files.path!);
      final jsonString = await file.readAsString();
      final dataList = jsonDecode(jsonString);

      for (final data in dataList) {
        isar.writeTxnSync(() {
          if (name == 'task') {
            try {
              final task = Tasks.fromJson(data);
              final existingTask =
                  tasks.firstWhereOrNull((t) => t.id == task.id);

              if (existingTask == null) {
                tasks.add(task);
              }
              isar.tasks.putSync(task);
              if (!taskSuccessShown) {
                EasyLoading.showSuccess('successRestoreCategory'.tr);
                taskSuccessShown = true;
              }
            } catch (e) {
              EasyLoading.showError('error'.tr);
              return Future.error(e);
            }
          } else if (name == 'todo') {
            try {
              final searchTask =
                  isar.tasks.filter().titleEqualTo('titleRe'.tr).findAllSync();
              final task = searchTask.isNotEmpty
                  ? searchTask.first
                  : Tasks(
                      title: 'titleRe'.tr,
                      description: 'descriptionRe'.tr,
                      taskColor: 4284513675,
                    );
              final existingTask =
                  tasks.firstWhereOrNull((t) => t.id == task.id);

              if (existingTask == null) {
                tasks.add(task);
              }
              isar.tasks.putSync(task);
              final todo = Todos.fromJson(data)..task.value = task;
              final existingTodos =
                  todos.firstWhereOrNull((t) => t.id == todo.id);
              if (existingTodos == null) {
                todos.add(todo);
              }
              isar.todos.putSync(todo);
              todo.task.saveSync();
              if (todo.todoCompletedTime != null) {
                NotificationShow().showNotification(
                  todo.id,
                  todo.name,
                  todo.description,
                  todo.todoCompletedTime,
                );
              }
              if (!todoSuccessShown) {
                EasyLoading.showSuccess('successRestoreTodo'.tr);
                todoSuccessShown = true;
              }
            } catch (e) {
              EasyLoading.showError('error'.tr);
              return Future.error(e);
            }
          } else {
            EasyLoading.showInfo('errorFile'.tr);
          }
        });
      }
    }
  }
}
