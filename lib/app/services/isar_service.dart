import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/notification.dart';

import 'package:todark/main.dart';

class IsarServices {
  final titleEdit = TextEditingController().obs;
  final descEdit = TextEditingController().obs;
  final timeEdit = TextEditingController().obs;
  final toggleValue = 0.obs;
  final tabIndex = 0.obs;
  final myColor = const Color(0xFF2196F3).obs;

  final countTotalTodos = 0.obs;
  final countDoneTodos = 0.obs;

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }

  Future<int> getCountTotalTodosCalendar(DateTime selectedDay) async {
    return isar.todos
        .filter()
        .todoCompletedTimeIsNotNull()
        .todoCompletedTimeBetween(
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 23, 59))
        .task((q) => q.archiveEqualTo(false))
        .count();
  }

  Future<int> getCountDoneTodosCalendar(DateTime selectedDay) async {
    return isar.todos
        .filter()
        .doneEqualTo(true)
        .todoCompletedTimeIsNotNull()
        .todoCompletedTimeBetween(
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
            DateTime(
                selectedDay.year, selectedDay.month, selectedDay.day, 23, 59))
        .task((q) => q.archiveEqualTo(false))
        .count();
  }

  Future<int> getCountTotalTodos() async {
    return isar.todos.filter().task((q) => q.archiveEqualTo(false)).count();
  }

  Future<int> getCountDoneTodos() async {
    return isar.todos
        .filter()
        .doneEqualTo(true)
        .task((q) => q.archiveEqualTo(false))
        .count();
  }

  Future<int> getCountTotalTodosTask(Tasks task) async {
    return isar.todos.filter().task((q) => q.idEqualTo(task.id)).count();
  }

  Future<int> getCountDoneTodosTask(Tasks task) async {
    return isar.todos
        .filter()
        .doneEqualTo(true)
        .task((q) => q.idEqualTo(task.id))
        .count();
  }

  Stream<List<Tasks>> getTask(int toggle) async* {
    yield* toggle == 0
        ? isar.tasks.filter().archiveEqualTo(false).watch(fireImmediately: true)
        : isar.tasks.filter().archiveEqualTo(true).watch(fireImmediately: true);
  }

  Stream<List<Todos>> getTodo(int toggle, Tasks task) async* {
    yield* toggle == 0
        ? isar.todos
            .filter()
            .task((q) => q.idEqualTo(task.id))
            .doneEqualTo(false)
            .watch(fireImmediately: true)
        : isar.todos
            .filter()
            .task((q) => q.idEqualTo(task.id))
            .doneEqualTo(true)
            .watch(fireImmediately: true);
  }

  Stream<List<Todos>> getAllTodo(int toggle) async* {
    yield* toggle == 0
        ? isar.todos
            .filter()
            .doneEqualTo(false)
            .task((q) => q.archiveEqualTo(false))
            .watch(fireImmediately: true)
        : isar.todos
            .filter()
            .doneEqualTo(true)
            .task((q) => q.archiveEqualTo(false))
            .watch(fireImmediately: true);
  }

  Stream<List<Todos>> getCalendarTodo(int toggle, DateTime selectedDay) async* {
    yield* toggle == 0
        ? isar.todos
            .filter()
            .doneEqualTo(false)
            .todoCompletedTimeIsNotNull()
            .todoCompletedTimeBetween(
                DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
                DateTime(selectedDay.year, selectedDay.month, selectedDay.day,
                    23, 59))
            .task((q) => q.archiveEqualTo(false))
            .watch(fireImmediately: true)
        : isar.todos
            .filter()
            .doneEqualTo(true)
            .todoCompletedTimeIsNotNull()
            .todoCompletedTimeBetween(
                DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day, 0, 0),
                DateTime(selectedDay.year, selectedDay.month, selectedDay.day,
                    23, 59))
            .task((q) => q.archiveEqualTo(false))
            .watch(fireImmediately: true);
  }

  Future<void> addTask(TextEditingController titleEdit,
      TextEditingController descEdit, Color myColor) async {
    final taskCreate = Tasks(
      title: titleEdit.text,
      description: descEdit.text,
      taskColor: myColor.hashCode,
    );

    List<Tasks> searchTask;
    final taskCollection = isar.tasks;

    searchTask =
        await taskCollection.filter().titleEqualTo(titleEdit.text).findAll();

    if (searchTask.isEmpty) {
      await isar.writeTxn(() async {
        await isar.tasks.put(taskCreate);
      });
      EasyLoading.showSuccess('createCategory'.tr,
          duration: const Duration(milliseconds: 500));
    } else {
      EasyLoading.showError('duplicateCategory'.tr,
          duration: const Duration(milliseconds: 500));
    }

    titleEdit.clear();
    descEdit.clear();
    myColor = const Color(0xFF2196F3);
  }

  Future<void> addTodo(
      Tasks task,
      TextEditingController titleEdit,
      TextEditingController descEdit,
      TextEditingController timeEdit,
      Function() set) async {
    final todosCreate = Todos(
      name: titleEdit.text,
      description: descEdit.text,
      todoCompletedTime: DateTime.tryParse(timeEdit.text),
    )..task.value = task;

    final todosCollection = isar.todos;
    List<Todos> getTodos;

    getTodos = await todosCollection
        .filter()
        .nameEqualTo(titleEdit.text)
        .task((q) => q.idEqualTo(task.id))
        .findAll();

    if (getTodos.isEmpty) {
      await isar.writeTxn(() async {
        await isar.todos.put(todosCreate);
        await todosCreate.task.save();
        if (todosCreate.todoCompletedTime != null) {
          NotificationShow().showNotification(
            todosCreate.id,
            todosCreate.name,
            todosCreate.description,
            todosCreate.todoCompletedTime,
          );
        }
      });
      EasyLoading.showSuccess('taskCreate'.tr,
          duration: const Duration(milliseconds: 500));
    } else {
      EasyLoading.showError('duplicateTask'.tr,
          duration: const Duration(milliseconds: 500));
    }
    titleEdit.clear();
    descEdit.clear();
    timeEdit.clear();
    set();
  }

  Future<void> updateTask(Tasks task, TextEditingController timeEdit,
      TextEditingController descEdit, Color myColor) async {
    await isar.writeTxn(() async {
      task.title = timeEdit.text;
      task.description = descEdit.text;
      task.taskColor = myColor.hashCode;
      await isar.tasks.put(task);
    });
    EasyLoading.showSuccess('editCategory'.tr,
        duration: const Duration(milliseconds: 500));
  }

  Future<void> updateTodoCheck(Todos todo, Function() set) async {
    await isar.writeTxn(() async => isar.todos.put(todo));
    set();
  }

  Future<void> updateTodo(
      Todos todo,
      Tasks task,
      TextEditingController titleEdit,
      TextEditingController descEdit,
      TextEditingController timeEdit) async {
    await isar.writeTxn(() async {
      todo.name = titleEdit.text;
      todo.description = descEdit.text;
      todo.todoCompletedTime = DateTime.tryParse(timeEdit.text);
      todo.task.value = task;
      await isar.todos.put(todo);
      await todo.task.save();
      await flutterLocalNotificationsPlugin.cancel(todo.id);
      if (todo.todoCompletedTime != null) {
        NotificationShow().showNotification(
          todo.id,
          todo.name,
          todo.description,
          todo.todoCompletedTime,
        );
      }
    });
    EasyLoading.showSuccess('update'.tr,
        duration: const Duration(milliseconds: 500));
  }

  Future<void> deleteTodo(Todos todos, Function() set) async {
    await isar.writeTxn(() async {
      await isar.todos.delete(todos.id);
      if (todos.todoCompletedTime != null) {
        await flutterLocalNotificationsPlugin.cancel(todos.id);
      }
    });
    EasyLoading.showSuccess('taskDelete'.tr,
        duration: const Duration(milliseconds: 500));
    set();
  }

  Future<void> deleteTask(Tasks task, Function() set) async {
    // Delete Notification
    List<Todos> getTodo;
    final taskCollection = isar.todos;
    getTodo = await taskCollection
        .filter()
        .task((q) => q.idEqualTo(task.id))
        .findAll();

    for (var element in getTodo) {
      if (element.todoCompletedTime != null) {
        await flutterLocalNotificationsPlugin.cancel(element.id);
      }
    }
    // Delete Todos
    await isar.writeTxn(() async {
      await isar.todos.filter().task((q) => q.idEqualTo(task.id)).deleteAll();
    });
    // Delete Task
    await isar.writeTxn(() async {
      await isar.tasks.delete(task.id);
    });
    EasyLoading.showSuccess('categoryDelete'.tr,
        duration: const Duration(milliseconds: 500));
    set();
  }

  Future<void> archiveTask(Tasks task, Function() set) async {
    // Delete Notification
    List<Todos> getTodo;
    final taskCollection = isar.todos;
    getTodo = await taskCollection
        .filter()
        .task((q) => q.idEqualTo(task.id))
        .findAll();

    for (var element in getTodo) {
      if (element.todoCompletedTime != null) {
        await flutterLocalNotificationsPlugin.cancel(element.id);
      }
    }
    // Archive Task
    await isar.writeTxn(() async {
      task.archive = true;
      await isar.tasks.put(task);
    });
    EasyLoading.showSuccess('taskArchive'.tr,
        duration: const Duration(milliseconds: 500));
    set();
  }

  Future<void> noArchiveTask(Tasks task, Function() set) async {
    // No archive Task
    await isar.writeTxn(() async {
      task.archive = false;
      await isar.tasks.put(task);
    });
    EasyLoading.showSuccess('noTaskArchive'.tr,
        duration: const Duration(milliseconds: 500));
    // Create Notification
    List<Todos> getTodo;
    final taskCollection = isar.todos;
    getTodo = await taskCollection
        .filter()
        .task((q) => q.idEqualTo(task.id))
        .findAll();

    for (var element in getTodo) {
      if (element.todoCompletedTime != null) {
        NotificationShow().showNotification(
          element.id,
          element.name,
          element.description,
          element.todoCompletedTime,
        );
      }
    }
    set();
  }
}
