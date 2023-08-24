import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/notification.dart';
import 'package:todark/main.dart';

class TodoController extends GetxController {
  final tasksActive = <Tasks>[].obs;
  final tasksArchive = <Tasks>[].obs;

  @override
  void onInit() {
    super.onInit();
    tasksActive.assignAll(
        isar.tasks.filter().archiveEqualTo(false).sortByIndex().findAllSync());
    tasksArchive.assignAll(
        isar.tasks.filter().archiveEqualTo(true).sortByIndex().findAllSync());
  }

  Stream<List<Todos>> getTodo(bool toggle, Tasks task) async* {
    yield* toggle == false
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

  Stream<List<Todos>> getAllTodo(bool toggle) async* {
    yield* toggle == false
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

  Stream<List<Todos>> getCalendarTodo(
      bool toggle, DateTime selectedDay) async* {
    yield* toggle == false
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
            .sortByTodoCompletedTime()
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
            .sortByTodoCompletedTime()
            .watch(fireImmediately: true);
  }

  Future<void> addTask(String title, String desc, Color myColor) async {
    final taskCreate = Tasks(
      title: title,
      description: desc,
      taskColor: myColor.value,
    );

    List<Tasks> searchTask;
    final taskCollection = isar.tasks;

    searchTask = await taskCollection.filter().titleEqualTo(title).findAll();

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
    myColor = const Color(0xFF2196F3);
  }

  Future<void> addTodo(
      Tasks task, String title, String desc, String time) async {
    DateTime? date;
    if (time.isNotEmpty) {
      date = DateFormat.yMMMEd(locale.languageCode).add_Hm().parse(time);
    }
    final todosCreate = Todos(
      name: title,
      description: desc,
      todoCompletedTime: date,
    )..task.value = task;

    final todosCollection = isar.todos;
    List<Todos> getTodos;

    getTodos = await todosCollection
        .filter()
        .nameEqualTo(title)
        .task((q) => q.idEqualTo(task.id))
        .todoCompletedTimeEqualTo(date)
        .findAll();

    if (getTodos.isEmpty) {
      await isar.writeTxn(() async {
        await isar.todos.put(todosCreate);
        await todosCreate.task.save();
        if (time.isNotEmpty) {
          NotificationShow().showNotification(
            todosCreate.id,
            todosCreate.name!,
            todosCreate.description!,
            date,
          );
        }
      });
      EasyLoading.showSuccess('taskCreate'.tr,
          duration: const Duration(milliseconds: 500));
    } else {
      EasyLoading.showError('duplicateTask'.tr,
          duration: const Duration(milliseconds: 500));
    }
  }

  Future<void> updateTask(
      Tasks task, String time, String desc, Color myColor) async {
    await isar.writeTxn(() async {
      task.title = time;
      task.description = desc;
      task.taskColor = myColor.value;
      await isar.tasks.put(task);
    });
    EasyLoading.showSuccess('editCategory'.tr,
        duration: const Duration(milliseconds: 500));
  }

  Future<void> updateTodoCheck(Todos todo) async {
    await isar.writeTxn(() async => isar.todos.put(todo));
  }

  Future<void> updateTodo(
      Todos todo, Tasks task, String title, String desc, String time) async {
    DateTime? date;
    if (time.isNotEmpty) {
      date = DateFormat.yMMMEd(locale.languageCode).add_Hm().parse(time);
    }
    await isar.writeTxn(() async {
      todo.name = title;
      todo.description = desc;
      todo.todoCompletedTime = date;
      todo.task.value = task;
      await isar.todos.put(todo);
      await todo.task.save();
      if (time.isNotEmpty) {
        await flutterLocalNotificationsPlugin.cancel(todo.id);
        NotificationShow().showNotification(
          todo.id,
          todo.name!,
          todo.description!,
          date,
        );
      } else {
        await flutterLocalNotificationsPlugin.cancel(todo.id);
      }
    });

    EasyLoading.showSuccess('update'.tr,
        duration: const Duration(milliseconds: 500));
  }

  Future<void> deleteTodo(Todos todo) async {
    await isar.writeTxn(() async {
      await isar.todos.delete(todo.id);
      if (todo.todoCompletedTime != null) {
        await flutterLocalNotificationsPlugin.cancel(todo.id);
      }
    });
    EasyLoading.showSuccess('taskDelete'.tr,
        duration: const Duration(milliseconds: 500));
  }

  Future<void> deleteTask(Tasks task) async {
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
  }

  Future<void> archiveTask(Tasks task) async {
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
  }

  Future<void> noArchiveTask(Tasks task) async {
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
          element.name!,
          element.description!,
          element.todoCompletedTime,
        );
      }
    }
    // No archive Task
    await isar.writeTxn(() async {
      task.archive = false;
      await isar.tasks.put(task);
    });
    EasyLoading.showSuccess('noTaskArchive'.tr,
        duration: const Duration(milliseconds: 500));
  }
}
