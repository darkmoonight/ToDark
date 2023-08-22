import 'dart:async';
import 'package:intl/intl.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/controller.dart';
import 'package:todark/app/services/notification.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../main.dart';

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
  final locale = Get.locale;

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
                return StatefulBuilder(
                  builder: (context, innerState) {
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
                                        onPressed: () =>
                                            Get.back(result: false),
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
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  showModalBottomSheet(
                                    enableDrag: false,
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return TodosCe(
                                        text: 'editing'.tr,
                                        edit: true,
                                        todo: todosList,
                                        category: true,
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: todosList.done,
                                            shape: const CircleBorder(),
                                            onChanged: (val) {
                                              innerState(() {
                                                todosList.done = val!;
                                              });
                                              todosList.done == true
                                                  ? flutterLocalNotificationsPlugin
                                                      .cancel(todosList.id)
                                                  : todosList.todoCompletedTime !=
                                                          null
                                                      ? NotificationShow()
                                                          .showNotification(
                                                          todosList.id,
                                                          todosList.name!,
                                                          todosList
                                                              .description!,
                                                          todosList
                                                              .todoCompletedTime,
                                                        )
                                                      : null;
                                              Future.delayed(
                                                const Duration(
                                                    milliseconds: 300),
                                                () {
                                                  todoController
                                                      .updateTodoCheck(
                                                          todosList);
                                                },
                                              );
                                            },
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  todosList.name!,
                                                  style: context
                                                      .textTheme.titleLarge
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                  overflow:
                                                      TextOverflow.visible,
                                                ),
                                                todosList
                                                        .description!.isNotEmpty
                                                    ? Text(
                                                        todosList.description!,
                                                        style: context.textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                          color: Colors.grey,
                                                        ),
                                                        overflow: TextOverflow
                                                            .visible,
                                                      )
                                                    : const SizedBox.shrink(),
                                                widget.allTask ||
                                                        widget.calendare
                                                    ? Text(
                                                        todosList
                                                            .task.value!.title!,
                                                        style: context
                                                            .textTheme.bodyLarge
                                                            ?.copyWith(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                todosList.todoCompletedTime !=
                                                            null &&
                                                        widget.calendare ==
                                                            false
                                                    ? Text(
                                                        todosList.todoCompletedTime !=
                                                                null
                                                            ? DateFormat.yMMMEd(
                                                                    locale
                                                                        ?.languageCode)
                                                                .add_Hm()
                                                                .format(todosList
                                                                    .todoCompletedTime!)
                                                            : '',
                                                        style: context.textTheme
                                                            .labelLarge,
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    widget.calendare
                                        ? Text(
                                            DateFormat.Hm(locale?.languageCode)
                                                .format(todosList
                                                    .todoCompletedTime!),
                                            style: context.textTheme.bodyLarge
                                                ?.copyWith(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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
