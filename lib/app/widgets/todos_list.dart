import 'dart:async';
import 'package:intl/intl.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/isar_service.dart';
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
    required this.toggle,
    required this.set,
    this.task,
    this.selectedDay,
  });
  final DateTime? selectedDay;
  final bool calendare;
  final bool allTask;
  final Tasks? task;
  final bool toggle;
  final Function() set;

  @override
  State<TodosList> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  final service = IsarServices();
  final locale = Get.locale;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      <MaterialState>{
        MaterialState.pressed,
      };
      return Get.isDarkMode ? Colors.white : Colors.black;
    }

    return StreamBuilder<List<Todos>>(
      stream: widget.allTask == true
          ? service.getAllTodo(widget.toggle)
          : widget.calendare == true
              ? service.getCalendarTodo(widget.toggle, widget.selectedDay!)
              : service.getTodo(widget.toggle, widget.task!),
      builder: (BuildContext context, AsyncSnapshot<List<Todos>> listData) {
        switch (listData.connectionState) {
          case ConnectionState.done:
          default:
            if (listData.hasData) {
              final todos = listData.data!;
              if (todos.isEmpty) {
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/AddTasks.png',
                          scale: 5,
                        ),
                        Text(
                          widget.toggle == true
                              ? 'copletedTask'.tr
                              : 'addTask'.tr,
                          style: context.theme.textTheme.titleMedium?.copyWith(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
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
                                backgroundColor:
                                    context.theme.colorScheme.primaryContainer,
                                title: Text(
                                  "deletedTask".tr,
                                  style: context.theme.textTheme.titleLarge,
                                ),
                                content: Text("deletedTaskQuery".tr,
                                    style: context.theme.textTheme.titleMedium),
                                actions: [
                                  TextButton(
                                      onPressed: () => Get.back(result: false),
                                      child: Text("cancel".tr,
                                          style: context
                                              .theme.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Colors.blueAccent))),
                                  TextButton(
                                      onPressed: () => Get.back(result: true),
                                      child: Text("delete".tr,
                                          style: context
                                              .theme.textTheme.titleMedium
                                              ?.copyWith(color: Colors.red))),
                                ],
                              );
                            },
                          );
                        },
                        onDismissed: (DismissDirection direction) {
                          service.deleteTodo(todosList, widget.set);
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
                        child: Container(
                          margin: const EdgeInsets.only(
                              right: 20, left: 20, bottom: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            // color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                enableDrag: false,
                                backgroundColor:
                                    context.theme.scaffoldBackgroundColor,
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return TodosCe(
                                    text: 'editing'.tr,
                                    edit: true,
                                    todo: todosList,
                                    category: true,
                                    set: widget.set,
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
                                        checkColor: Get.isDarkMode
                                            ? Colors.black
                                            : Colors.white,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                getColor),
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
                                                      todosList.name,
                                                      todosList.description,
                                                      todosList
                                                          .todoCompletedTime,
                                                    )
                                                  : null;
                                          Future.delayed(
                                            const Duration(milliseconds: 300),
                                            () {
                                              service.updateTodoCheck(
                                                  todosList, widget.set);
                                            },
                                          );
                                        },
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                todosList.name,
                                                style: context
                                                    .theme.textTheme.titleLarge
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 18,
                                                  color: todosList.todoCompletedTime !=
                                                              null &&
                                                          DateTime.now()
                                                              .isAfter(todosList
                                                                  .todoCompletedTime!) &&
                                                          todosList.done ==
                                                              false
                                                      ? Colors.redAccent
                                                      : Get.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                                overflow: TextOverflow.visible,
                                              ),
                                              todosList.description.isNotEmpty
                                                  ? Text(
                                                      todosList.description,
                                                      style: context.theme
                                                          .textTheme.bodyLarge
                                                          ?.copyWith(
                                                        fontSize: 12,
                                                        color: Colors.grey[700],
                                                      ),
                                                      overflow:
                                                          TextOverflow.visible,
                                                    )
                                                  : Container(),
                                              todosList.todoCompletedTime !=
                                                          null &&
                                                      widget.calendare == false
                                                  ? Text(
                                                      todosList.todoCompletedTime !=
                                                              null
                                                          ? DateFormat(
                                                              'dd MMM yyyy HH:mm',
                                                              '${locale?.languageCode}',
                                                            ).format(todosList
                                                              .todoCompletedTime!)
                                                          : '',
                                                      style: context.theme
                                                          .textTheme.bodyLarge
                                                          ?.copyWith(
                                                        color: Get.isDarkMode
                                                            ? Colors.teal
                                                            : Colors.deepPurple,
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                widget.allTask == true
                                    ? Text(
                                        todosList.task.value!.title.length > 10
                                            ? todosList.task.value!.title
                                                .substring(0, 10)
                                            : todosList.task.value!.title,
                                        style: context.theme.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: Colors.grey[700],
                                          fontSize: 12,
                                        ),
                                      )
                                    : widget.calendare == true
                                        ? Text(
                                            '${todosList.task.value!.title.length > 10 ? todosList.task.value!.title.substring(0, 10) : todosList.task.value!.title}\n${DateFormat(
                                              'HH:mm',
                                              '${locale?.languageCode}',
                                            ).format(todosList.todoCompletedTime!)}',
                                            style: context
                                                .theme.textTheme.bodyLarge
                                                ?.copyWith(
                                              color: Colors.grey[700],
                                              fontSize: 12,
                                            ),
                                          )
                                        : Container(),
                              ],
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
    );
  }
}
