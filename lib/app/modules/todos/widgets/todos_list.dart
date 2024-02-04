import 'package:todark/app/data/schema.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todark/app/modules/todos/widgets/todo_card.dart';
import 'package:todark/app/modules/todos/widgets/todos_action.dart';
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

          if (widget.calendare) {
            todos.sort(
                (a, b) => a.todoCompletedTime!.compareTo(b.todoCompletedTime!));
          }

          return todos.isEmpty
              ? ListEmpty(
                  img: widget.calendare
                      ? 'assets/images/Calendar.png'
                      : 'assets/images/Todo.png',
                  text: widget.done ? 'completedTodo'.tr : 'addTodo'.tr,
                )
              : ListView(
                  children: [
                    ...todos.map(
                      (todo) => TodoCard(
                        key: ValueKey(todo),
                        todo: todo,
                        allTodos: widget.allTodos,
                        calendare: widget.calendare,
                        onTap: () {
                          todoController.isMultiSelectionTodo.isTrue
                              ? todoController.doMultiSelectionTodo(todo)
                              : showModalBottomSheet(
                                  enableDrag: false,
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return TodosAction(
                                      text: 'editing'.tr,
                                      edit: true,
                                      todo: todo,
                                      category: true,
                                    );
                                  },
                                );
                        },
                        onLongPress: () {
                          todoController.isMultiSelectionTodo.value = true;
                          todoController.doMultiSelectionTodo(todo);
                        },
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
