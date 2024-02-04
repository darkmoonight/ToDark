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

  final selectedTask = <Tasks>[].obs;
  final isMultiSelectionTask = false.obs;

  final selectedTodo = <Todos>[].obs;
  final isMultiSelectionTodo = false.obs;

  RxBool isPop = true.obs;

  final duration = const Duration(milliseconds: 500);
  var now = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(isar.tasks.where().findAllSync());
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
      tasks.add(taskCreate);
      isar.writeTxnSync(() => isar.tasks.putSync(taskCreate));
      EasyLoading.showSuccess('createCategory'.tr, duration: duration);
    } else {
      EasyLoading.showError('duplicateCategory'.tr, duration: duration);
    }
  }

  Future<void> updateTask(
      Tasks task, String title, String desc, Color myColor) async {
    isar.writeTxnSync(() {
      task.title = title;
      task.description = desc;
      task.taskColor = myColor.value;
      isar.tasks.putSync(task);
    });

    var newTask = task;
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    todos.refresh();

    EasyLoading.showSuccess('editCategory'.tr, duration: duration);
  }

  Future<void> deleteTask(List<Tasks> taskList) async {
    List<Tasks> taskListCopy = List.from(taskList);

    for (var task in taskListCopy) {
      // Delete Notification
      List<Todos> getTodo;
      getTodo =
          isar.todos.filter().task((q) => q.idEqualTo(task.id)).findAllSync();

      for (var todo in getTodo) {
        if (todo.todoCompletedTime != null) {
          if (todo.todoCompletedTime!.isAfter(now)) {
            await flutterLocalNotificationsPlugin.cancel(todo.id);
          }
        }
      }
      // Delete Todos
      todos.removeWhere((todo) => todo.task.value?.id == task.id);
      isar.writeTxnSync(() => isar.todos
          .filter()
          .task((q) => q.idEqualTo(task.id))
          .deleteAllSync());

      // Delete Task
      tasks.remove(task);
      isar.writeTxnSync(() => isar.tasks.deleteSync(task.id));
      EasyLoading.showSuccess('categoryDelete'.tr, duration: duration);
    }
  }

  Future<void> archiveTask(List<Tasks> taskList) async {
    List<Tasks> taskListCopy = List.from(taskList);

    for (var task in taskListCopy) {
      // Delete Notification
      List<Todos> getTodo;
      getTodo =
          isar.todos.filter().task((q) => q.idEqualTo(task.id)).findAllSync();

      for (var todo in getTodo) {
        if (todo.todoCompletedTime != null) {
          if (todo.todoCompletedTime!.isAfter(now)) {
            await flutterLocalNotificationsPlugin.cancel(todo.id);
          }
        }
      }
      // Archive Task
      isar.writeTxnSync(() {
        task.archive = true;
        isar.tasks.putSync(task);
      });
      tasks.refresh();
      todos.refresh();
      EasyLoading.showSuccess('categoryArchive'.tr, duration: duration);
    }
  }

  Future<void> noArchiveTask(List<Tasks> taskList) async {
    List<Tasks> taskListCopy = List.from(taskList);

    for (var task in taskListCopy) {
      // Create Notification
      List<Todos> getTodo;
      getTodo =
          isar.todos.filter().task((q) => q.idEqualTo(task.id)).findAllSync();

      for (var todo in getTodo) {
        if (todo.todoCompletedTime != null) {
          if (todo.todoCompletedTime!.isAfter(now)) {
            NotificationShow().showNotification(
              todo.id,
              todo.name,
              todo.description,
              todo.todoCompletedTime,
            );
          }
        }
      }
      // No archive Task
      isar.writeTxnSync(() {
        task.archive = false;
        isar.tasks.putSync(task);
      });
      tasks.refresh();
      todos.refresh();
      EasyLoading.showSuccess('noCategoryArchive'.tr, duration: duration);
    }
  }

  // Todos
  Future<void> addTodo(
      Tasks task, String title, String desc, String time) async {
    DateTime? date;
    if (time.isNotEmpty) {
      date = timeformat == '12'
          ? DateFormat.yMMMEd(locale.languageCode).add_jm().parse(time)
          : DateFormat.yMMMEd(locale.languageCode).add_Hm().parse(time);
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
      todos.add(todosCreate);
      isar.writeTxnSync(() {
        isar.todos.putSync(todosCreate);
        todosCreate.task.saveSync();
      });
      if (time.isNotEmpty) {
        NotificationShow().showNotification(
          todosCreate.id,
          todosCreate.name,
          todosCreate.description,
          date,
        );
      }
      EasyLoading.showSuccess('todoCreate'.tr, duration: duration);
    } else {
      EasyLoading.showError('duplicateTodo'.tr, duration: duration);
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
      date = timeformat == '12'
          ? DateFormat.yMMMEd(locale.languageCode).add_jm().parse(time)
          : DateFormat.yMMMEd(locale.languageCode).add_Hm().parse(time);
    }
    isar.writeTxnSync(() {
      todo.name = title;
      todo.description = desc;
      todo.todoCompletedTime = date;
      todo.task.value = task;
      isar.todos.putSync(todo);
      todo.task.saveSync();
    });

    var newTodo = todo;
    int oldIdx = todos.indexOf(todo);
    todos[oldIdx] = newTodo;
    todos.refresh();

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
    EasyLoading.showSuccess('updateTodo'.tr, duration: duration);
  }

  Future<void> deleteTodo(List<Todos> todoList) async {
    List<Todos> todoListCopy = List.from(todoList);

    for (var todo in todoListCopy) {
      if (todo.todoCompletedTime != null) {
        if (todo.todoCompletedTime!.isAfter(now)) {
          await flutterLocalNotificationsPlugin.cancel(todo.id);
        }
      }
      todos.remove(todo);
      isar.writeTxnSync(() => isar.todos.deleteSync(todo.id));
      EasyLoading.showSuccess('todoDelete'.tr, duration: duration);
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

  void doMultiSelectionTask(Tasks tasks) {
    if (isMultiSelectionTask.isTrue) {
      isPop.value = false;
      if (selectedTask.contains(tasks)) {
        selectedTask.remove(tasks);
      } else {
        selectedTask.add(tasks);
      }

      if (selectedTask.isEmpty) {
        isMultiSelectionTask.value = false;
        isPop.value = true;
      }
    }
  }

  void doMultiSelectionTaskClear() {
    selectedTask.clear();
    isMultiSelectionTask.value = false;
    isPop.value = true;
  }

  void doMultiSelectionTodo(Todos todos) {
    if (isMultiSelectionTodo.isTrue) {
      isPop.value = false;
      if (selectedTodo.contains(todos)) {
        selectedTodo.remove(todos);
      } else {
        selectedTodo.add(todos);
      }

      if (selectedTodo.isEmpty) {
        isMultiSelectionTodo.value = false;
        isPop.value = true;
      }
    }
  }

  void doMultiSelectionTodoClear() {
    selectedTodo.clear();
    isMultiSelectionTodo.value = false;
    isPop.value = true;
  }
}
