import 'package:todark/app/data/schema.dart';
import 'package:todark/app/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/modules/todos/widgets/todo_card.dart';
import 'package:todark/app/widgets/list_empty.dart';

class TodosList extends StatefulWidget {
  const TodosList({
    super.key,
    required this.done,
    this.task,
    required this.allTodos,
    required this.calendare,
    this.selectedDay,
    required this.searchTodo,
  });
  final bool done;
  final Tasks? task;
  final bool allTodos;
  final bool calendare;
  final DateTime? selectedDay;
  final String searchTodo;

  @override
  State<TodosList> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Obx(
        () {
          var todos = widget.task != null
              ? todoController.todos
                  .where((todo) =>
                      todo.task.value?.id == widget.task?.id &&
                      todo.done == widget.done &&
                      (widget.searchTodo.isEmpty ||
                          todo.name.toLowerCase().contains(widget.searchTodo)))
                  .toList()
                  .obs
              : widget.allTodos
                  ? todoController.todos
                      .where((todo) =>
                          todo.task.value?.archive == false &&
                          todo.done == widget.done &&
                          (widget.searchTodo.isEmpty ||
                              todo.name
                                  .toLowerCase()
                                  .contains(widget.searchTodo)))
                      .toList()
                      .obs
                  : widget.calendare
                      ? todoController.todos
                          .where((todo) =>
                              todo.task.value?.archive == false &&
                              todo.todoCompletedTime != null &&
                              todo.todoCompletedTime!.isAfter(
                                DateTime(
                                    widget.selectedDay!.year,
                                    widget.selectedDay!.month,
                                    widget.selectedDay!.day,
                                    0,
                                    0),
                              ) &&
                              todo.todoCompletedTime!.isBefore(
                                DateTime(
                                    widget.selectedDay!.year,
                                    widget.selectedDay!.month,
                                    widget.selectedDay!.day,
                                    23,
                                    59),
                              ) &&
                              todo.done == widget.done)
                          .toList()
                          .obs
                      : todoController.todos;
          return todos.isEmpty
              ? ListEmpty(
                  img: widget.calendare
                      ? 'assets/images/Calendar.png'
                      : 'assets/images/Todo.png',
                  text: widget.done == true ? 'copletedTask'.tr : 'addTask'.tr,
                )
              : ListView(
                  children: [
                    ...todos
                        .map(
                          (todosList) => Dismissible(
                            key: ValueKey(todosList),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (DismissDirection direction) async {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'deletedTask'.tr,
                                      style: context.textTheme.titleLarge,
                                    ),
                                    content: Text(
                                      'deletedTaskQuery'.tr,
                                      style: context.textTheme.titleMedium,
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Get.back(result: false),
                                          child: Text('cancel'.tr,
                                              style: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                      color:
                                                          Colors.blueAccent))),
                                      TextButton(
                                          onPressed: () =>
                                              Get.back(result: true),
                                          child: Text('delete'.tr,
                                              style: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors.red))),
                                    ],
                                  );
                                },
                              );
                            },
                            onDismissed: (DismissDirection direction) {
                              todoController.deleteTodo(todosList);
                            },
                            background: Container(
                              alignment: Alignment.centerRight,
                              child: const Padding(
                                padding: EdgeInsets.only(
                                  right: 15,
                                ),
                                child: Icon(
                                  Iconsax.trush_square,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            child: TodoCard(
                              todos: todosList,
                              allTodos: widget.allTodos,
                              calendare: widget.calendare,
                            ),
                          ),
                        )
                        .toList(),
                  ],
                );
        },
      ),
    );
  }
}
