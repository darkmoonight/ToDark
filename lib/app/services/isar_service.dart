import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:isar/isar.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/notification.dart';
import 'package:todark/main.dart';

class IsarServices {
  final titleEdit = TextEditingController().obs;
  final descEdit = TextEditingController().obs;
  final timeEdit = TextEditingController().obs;
  final toggleValue = false.obs;
  final myColor = const Color(0xFF2196F3).obs;

  final MaterialStateProperty<Icon?> thumbIconTodo =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Iconsax.tick_circle);
      }
      return const Icon(Iconsax.close_circle);
    },
  );

  final MaterialStateProperty<Icon?> thumbIconTask =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Iconsax.archive_tick);
      }
      return const Icon(Iconsax.archive_minus);
    },
  );

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

  Stream<List<Tasks>> getTask(bool toggle) async* {
    yield* toggle == false
        ? isar.tasks.filter().archiveEqualTo(false).watch(fireImmediately: true)
        : isar.tasks.filter().archiveEqualTo(true).watch(fireImmediately: true);
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

  Future<void> addTask(TextEditingController titleEdit,
      TextEditingController descEdit, Color myColor) async {
    final taskCreate = Tasks(
      title: titleEdit.text,
      description: descEdit.text,
      taskColor: myColor.value,
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
        .todoCompletedTimeEqualTo(DateTime.tryParse(timeEdit.text))
        .findAll();

    if (getTodos.isEmpty) {
      await isar.writeTxn(() async {
        await isar.todos.put(todosCreate);
        await todosCreate.task.save();
        if (timeEdit.text.isNotEmpty) {
          NotificationShow().showNotification(
            todosCreate.id,
            todosCreate.name,
            todosCreate.description,
            DateTime.tryParse(timeEdit.text),
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
      task.taskColor = myColor.value;
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
      TextEditingController timeEdit,
      Function() set) async {
    await isar.writeTxn(() async {
      todo.name = titleEdit.text;
      todo.description = descEdit.text;
      todo.todoCompletedTime = DateTime.tryParse(timeEdit.text);
      todo.task.value = task;
      await isar.todos.put(todo);
      await todo.task.save();
      if (timeEdit.text.isNotEmpty) {
        await flutterLocalNotificationsPlugin.cancel(todo.id);
        NotificationShow().showNotification(
          todo.id,
          todo.name,
          todo.description,
          DateTime.tryParse(timeEdit.text),
        );
      } else {
        await flutterLocalNotificationsPlugin.cancel(todo.id);
      }
    });

    EasyLoading.showSuccess('update'.tr,
        duration: const Duration(milliseconds: 500));
    set();
  }

  Future<void> deleteTodo(Todos todo, Function() set) async {
    await isar.writeTxn(() async {
      await isar.todos.delete(todo.id);
      if (todo.todoCompletedTime != null) {
        await flutterLocalNotificationsPlugin.cancel(todo.id);
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
    // No archive Task
    await isar.writeTxn(() async {
      task.archive = false;
      await isar.tasks.put(task);
    });
    EasyLoading.showSuccess('noTaskArchive'.tr,
        duration: const Duration(milliseconds: 500));
    set();
  }
}
