import 'package:todark/app/data/schema.dart';
import 'package:todark/app/controller/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/modules/todos/widgets/todo_card.dart';

class TodosList extends StatefulWidget {
  const TodosList({
    super.key,
    required this.calendare,
    required this.allTask,
    required this.done,
    this.task,
    this.selectedDay,
  });
  final DateTime? selectedDay;
  final bool calendare;
  final bool allTask;
  final Tasks? task;
  final bool done;

  @override
  State<TodosList> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: StreamBuilder<List<Todos>>(
        stream: widget.allTask == true
            ? todoController.getAllTodo(widget.done)
            : widget.calendare == true
                ? todoController.getCalendarTodo(
                    widget.done, widget.selectedDay!)
                : todoController.getTodo(widget.done, widget.task!),
        builder: (BuildContext context, AsyncSnapshot<List<Todos>> listData) {
          switch (listData.connectionState) {
            case ConnectionState.done:
            default:
              if (listData.hasData) {
                final todos = listData.data!;
                if (todos.isEmpty) {
                  return Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        widget.calendare
                            ? Image.asset(
                                'assets/images/Calendar.png',
                                scale: 5,
                              )
                            : Image.asset(
                                'assets/images/Todo.png',
                                scale: 5,
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            widget.done == true
                                ? 'copletedTask'.tr
                                : 'addTask'.tr,
                            textAlign: TextAlign.center,
                            style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final todosList = todos[index];
                    return Dismissible(
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
                                    onPressed: () => Get.back(result: false),
                                    child: Text('cancel'.tr,
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Colors.blueAccent))),
                                TextButton(
                                    onPressed: () => Get.back(result: true),
                                    child: Text('delete'.tr,
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(color: Colors.red))),
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
                        todosList: todosList,
                        allTask: widget.allTask,
                        calendare: widget.calendare,
                      ),
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
          }
        },
      ),
    );
  }
}
