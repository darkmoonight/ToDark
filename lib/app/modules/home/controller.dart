import 'dart:math';

import 'package:dark_todo/app/data/models/task.dart';
import 'package:dark_todo/app/data/services/storage/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;
  HomeController({required this.taskRepository});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> formKeyDialog = GlobalKey<FormFieldState>();
  final editCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final task = Rx<Task?>(null);
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;

  var random = Random();

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(tasks, (_) => taskRepository.writeTasks(tasks));
  }

  @override
  void onClose() {
    editCtrl.dispose();
    super.onClose();
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  void changeTask(Task? select) {
    task.value = select;
  }

  void changeTodos(List<dynamic> select) {
    doingTodos.clear();
    doneTodos.clear();
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  updateTask(Task task, int id, String title, String? desc, String? date) {
    var todos = task.todos ?? [];
    if (containeTodo(todos, title)) {
      return false;
    }
    var todo = {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'done': false
    };
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldIdx = tasks.indexOf(task);
    tasks[oldIdx] = newTask;
    tasks.refresh();
    return true;
  }

  bool containeTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  bool addTodo(int id, String title, String? desc, String? date) {
    var todo = {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'done': false
    };
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    var doneTodo = {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'done': true
    };
    if (doneTodos
        .any((element) => mapEquals<String, dynamic>(doneTodo, element))) {
      return false;
    }
    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[];
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);
    var newTask = task.value!.copyWith(todos: newTodos);
    int oldIdx = tasks.indexOf(task.value);
    tasks[oldIdx] = newTask;
    tasks.refresh();
  }

  void doneTodo(int id, String title, String? desc, String? date) {
    var doingTodo = {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'done': false
    };
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    var doneTodo = {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'done': true
    };
    doneTodos.add(doneTodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void doingTodo(int id, String title, String? desc, String? date) {
    var doneTodo = {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'done': true
    };
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);
    var doingTodo = {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'done': false
    };
    doingTodos.add(doingTodo);
    doneTodos.refresh();
    doingTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  void deleteDoingTodo(dynamic doingTodo) {
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    doingTodos.removeAt(index);
    doingTodos.refresh();
  }

  void updateDoingTodo(int id, String title, String? desc, String? date,
      String newTitle, String? newDesc, String? newDate) {
    var doingTodo = {
      'id': id,
      'title': title,
      'desc': desc,
      'date': date,
      'done': false
    };
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingTodo, element));
    var newDoingTodo = {
      'id': id,
      'title': newTitle,
      'desc': newDesc,
      'date': newDate,
      'done': false
    };
    doingTodos[index] = newDoingTodo;
    doingTodos.refresh();
  }

  bool isTodosEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res += 1;
      }
    }
    return res;
  }

  int getTotalTask() {
    var res = 0;
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

  int getTotalDoneTask() {
    var res = 0;
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (var j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done'] == true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}
