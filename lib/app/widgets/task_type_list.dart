import 'package:todark/app/data/schema.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../modules/tasks/view.dart';

class TaskTypeList extends StatefulWidget {
  const TaskTypeList({
    super.key,
    required this.isLoaded,
    required this.tasks,
    required this.onDelete,
    required this.back,
    required this.onDeleteTodos,
    required this.onArchive,
    required this.toggleValue,
    required this.onNoArchive,
  });
  final bool isLoaded;
  final int toggleValue;
  final List<Tasks> tasks;
  final Function(Tasks) onDelete;
  final Function(Tasks) onArchive;
  final Function(Tasks) onNoArchive;
  final Function(Tasks) onDeleteTodos;
  final Function() back;

  @override
  State<TaskTypeList> createState() => _TaskTypeListState();
}

class _TaskTypeListState extends State<TaskTypeList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: widget.isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Visibility(
          visible: widget.tasks.isNotEmpty,
          replacement: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/Starting.png',
                    scale: 5,
                  ),
                  SizedBox(
                    width: Get.size.width * 0.8,
                    child: Text(
                      widget.toggleValue == 0
                          ? 'addCategory'.tr
                          : 'addArchive'.tr,
                      textAlign: TextAlign.center,
                      style: context.theme.textTheme.headline4?.copyWith(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.tasks.length,
            itemBuilder: (BuildContext context, int index) {
              final task = widget.tasks[index];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.horizontal,
                confirmDismiss: (DismissDirection direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: context.theme.primaryColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        title: Text(
                          direction == DismissDirection.endToStart
                              ? "deleteCategory".tr
                              : widget.toggleValue == 0
                                  ? "archiveTask".tr
                                  : "noArchiveTask".tr,
                          style: context.theme.textTheme.headline4,
                        ),
                        content: Text(
                            direction == DismissDirection.endToStart
                                ? "deleteCategoryQuery".tr
                                : widget.toggleValue == 0
                                    ? "archiveTaskQuery".tr
                                    : "noArchiveTaskQuery".tr,
                            style: context.theme.textTheme.headline6),
                        actions: [
                          TextButton(
                              onPressed: () => Get.back(result: false),
                              child: Text("cancel".tr,
                                  style: context.theme.textTheme.headline6
                                      ?.copyWith(color: Colors.blueAccent))),
                          TextButton(
                              onPressed: () => Get.back(result: true),
                              child: Text(
                                  direction == DismissDirection.endToStart
                                      ? "delete".tr
                                      : widget.toggleValue == 0
                                          ? "archive".tr
                                          : "noArchive".tr,
                                  style: context.theme.textTheme.headline6
                                      ?.copyWith(color: Colors.red))),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (DismissDirection direction) {
                  if (direction == DismissDirection.endToStart) {
                    widget.onDeleteTodos(task);
                    widget.onDelete(task);
                  } else if (direction == DismissDirection.startToEnd) {
                    widget.toggleValue == 0
                        ? widget.onArchive(task)
                        : widget.onNoArchive(task);
                  }
                },
                background: Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 15,
                    ),
                    child: Icon(
                      widget.toggleValue == 0
                          ? Iconsax.archive_2
                          : Iconsax.refresh_left_square,
                      color:
                          widget.toggleValue == 0 ? Colors.red : Colors.green,
                    ),
                  ),
                ),
                secondaryBackground: Container(
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
                    bottom: 10,
                    top: 10,
                    left: 25,
                    right: 25,
                  ),
                  child: CupertinoButton(
                    minSize: double.minPositive,
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Get.to(
                        () => TaskPage(
                          back: () {
                            widget.back();
                          },
                          task: task,
                        ),
                        transition: Transition.downToUp,
                      );
                    },
                    child: Row(
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 60,
                                child: CircularStepProgressIndicator(
                                  totalSteps: task.todos.isNotEmpty
                                      ? task.todos.length
                                      : 1,
                                  currentStep: task.todos
                                      .where((e) => e.done == true)
                                      .toList()
                                      .length,
                                  stepSize: 4,
                                  selectedColor: Color(task.taskColor),
                                  unselectedColor: Colors.grey[300],
                                  padding: 0,
                                  selectedStepSize: 5,
                                  roundedCap: (_, __) => true,
                                  child: Center(
                                    child: Text(
                                      task.todos.isNotEmpty
                                          ? '${((task.todos.where((e) => e.done == true).toList().length / task.todos.length) * 100).round()}%'
                                          : '0%',
                                      style: context.theme.textTheme.headline6
                                          ?.copyWith(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: task.description.isNotEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task.title,
                                            style: context
                                                .theme.textTheme.headline4
                                                ?.copyWith(color: Colors.black),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            task.description,
                                            style: context
                                                .theme.textTheme.subtitle2,
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      )
                                    : Text(
                                        task.title,
                                        style: context.theme.textTheme.headline4
                                            ?.copyWith(color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${task.todos.where((e) => e.done == true).toList().length}/${task.todos.length}',
                          style: context.theme.textTheme.subtitle2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
