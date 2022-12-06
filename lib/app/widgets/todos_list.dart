import 'dart:async';

import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/services/notification.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:flutter/cupertino.dart';
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
  final int toggle;
  final Function() set;

  @override
  State<TodosList> createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  final service = IsarServices();

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      <MaterialState>{
        MaterialState.pressed,
      };
      return Colors.black;
    }

    return Expanded(
      child: StreamBuilder<List<Todos>>(
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
                            widget.toggle == 1
                                ? 'copletedTask'.tr
                                : 'addTask'.tr,
                            style: context.theme.textTheme.headline4?.copyWith(
                              color: Colors.black,
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
                      physics: const BouncingScrollPhysics(),
                      itemCount: listData.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        final todosList = todos[index];
                        return Dismissible(
                          key: ObjectKey(todosList),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (DismissDirection direction) async {
                            return await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: context.theme.primaryColor,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  title: Text(
                                    "deletedTask".tr,
                                    style: context.theme.textTheme.headline4,
                                  ),
                                  content: Text("deletedTaskQuery".tr,
                                      style: context.theme.textTheme.headline6),
                                  actions: [
                                    TextButton(
                                        onPressed: () =>
                                            Get.back(result: false),
                                        child: Text("cancel".tr,
                                            style: context
                                                .theme.textTheme.headline6
                                                ?.copyWith(
                                                    color: Colors.blueAccent))),
                                    TextButton(
                                        onPressed: () => Get.back(result: true),
                                        child: Text("delete".tr,
                                            style: context
                                                .theme.textTheme.headline6
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
                            child: CupertinoButton(
                              minSize: double.minPositive,
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                showModalBottomSheet(
                                  enableDrag: false,
                                  backgroundColor:
                                      context.theme.scaffoldBackgroundColor,
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
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
                                          checkColor: Colors.white,
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
                                                const Duration(
                                                    milliseconds: 300), () {
                                              service.updateTodoCheck(
                                                  todosList, widget.set);
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: todosList
                                                  .description.isNotEmpty
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        todosList.name,
                                                        style: todosList.todoCompletedTime !=
                                                                    null &&
                                                                DateTime.now()
                                                                    .isAfter(
                                                                        todosList
                                                                            .todoCompletedTime!) &&
                                                                todosList
                                                                        .done ==
                                                                    false
                                                            ? context
                                                                .theme
                                                                .textTheme
                                                                .headline4
                                                                ?.copyWith(
                                                                color: Colors
                                                                    .redAccent,
                                                              )
                                                            : context
                                                                .theme
                                                                .textTheme
                                                                .headline4
                                                                ?.copyWith(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        todosList.description,
                                                        style: context
                                                            .theme
                                                            .textTheme
                                                            .subtitle2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Text(
                                                  todosList.name,
                                                  style: todosList.todoCompletedTime !=
                                                              null &&
                                                          DateTime.now()
                                                              .isAfter(todosList
                                                                  .todoCompletedTime!) &&
                                                          todosList.done ==
                                                              false
                                                      ? context.theme.textTheme
                                                          .headline4
                                                          ?.copyWith(
                                                          color:
                                                              Colors.redAccent,
                                                        )
                                                      : context.theme.textTheme
                                                          .headline4
                                                          ?.copyWith(
                                                          color: Colors.black,
                                                        ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.allTask
                                      ? Text(
                                          todosList.todoCompletedTime != null
                                              ? '${todosList.task.value!.title}\n${todosList.todoCompletedTime?.day.toString().padLeft(2, '0')}/${todosList.todoCompletedTime?.month.toString().padLeft(2, '0')}/${todosList.todoCompletedTime?.year.toString().substring(2)}\n${todosList.todoCompletedTime?.hour.toString().padLeft(2, '0')}:${todosList.todoCompletedTime?.minute.toString().padLeft(2, '0')}'
                                              : todosList.task.value!.title,
                                          style:
                                              context.theme.textTheme.subtitle2,
                                        )
                                      : widget.calendare == true
                                          ? Text(
                                              '${todosList.task.value!.title}\n${todosList.todoCompletedTime?.hour.toString().padLeft(2, '0')}:${todosList.todoCompletedTime?.minute.toString().padLeft(2, '0')}',
                                              style: context
                                                  .theme.textTheme.subtitle2,
                                            )
                                          : Text(
                                              todosList.todoCompletedTime !=
                                                      null
                                                  ? '${todosList.todoCompletedTime?.day.toString().padLeft(2, '0')}/${todosList.todoCompletedTime?.month.toString().padLeft(2, '0')}/${todosList.todoCompletedTime?.year.toString().substring(2)}\n${todosList.todoCompletedTime?.hour.toString().padLeft(2, '0')}:${todosList.todoCompletedTime?.minute.toString().padLeft(2, '0')}'
                                                  : '',
                                              style: context
                                                  .theme.textTheme.subtitle2,
                                            ),
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
      ),
    );
  }
}
