import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/controller.dart';
import 'package:todark/app/widgets/task_card.dart';
import 'package:todark/main.dart';

class TaskTypeList extends StatefulWidget {
  const TaskTypeList({
    super.key,
    required this.archived,
    required this.tasks,
  });
  final bool archived;
  final RxList<Tasks> tasks;

  @override
  State<TaskTypeList> createState() => _TaskTypeListState();
}

class _TaskTypeListState extends State<TaskTypeList> {
  final todoController = Get.put(TodoController());

  void updateItemOrderInDatabase(List<Tasks> weatherCard) async {
    for (int i = 0; i < weatherCard.length; i++) {
      final item = weatherCard[i];
      item.index = i;
      isar.writeTxn(() async => await isar.tasks.put(item));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Obx(
        () => widget.tasks.isEmpty
            ? Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Image.asset(
                      'assets/images/Category.png',
                      scale: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        widget.archived == false
                            ? 'addCategory'.tr
                            : 'addArchive'.tr,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ReorderableListView.builder(
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final element = widget.tasks.removeAt(oldIndex);
                  widget.tasks.insert(newIndex, element);
                  updateItemOrderInDatabase(widget.tasks);
                },
                itemCount: widget.tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  final taskList = widget.tasks[index];
                  return Dismissible(
                    key: ValueKey(taskList),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              direction == DismissDirection.endToStart
                                  ? 'deleteCategory'.tr
                                  : widget.archived == false
                                      ? 'archiveTask'.tr
                                      : 'noArchiveTask'.tr,
                              style: context.textTheme.titleLarge,
                            ),
                            content: Text(
                              direction == DismissDirection.endToStart
                                  ? 'deleteCategoryQuery'.tr
                                  : widget.archived == false
                                      ? 'archiveTaskQuery'.tr
                                      : 'noArchiveTaskQuery'.tr,
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
                                  child: Text(
                                      direction == DismissDirection.endToStart
                                          ? 'delete'.tr
                                          : widget.archived == false
                                              ? 'archive'.tr
                                              : 'noArchive'.tr,
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(color: Colors.red))),
                            ],
                          );
                        },
                      );
                    },
                    onDismissed: (DismissDirection direction) {
                      if (direction == DismissDirection.endToStart) {
                        todoController.deleteTask(taskList);
                      } else if (direction == DismissDirection.startToEnd) {
                        widget.archived == false
                            ? todoController.archiveTask(taskList)
                            : todoController.noArchiveTask(taskList);
                      }
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Icon(
                          widget.archived == false
                              ? Iconsax.archive_2
                              : Iconsax.refresh_left_square,
                          color: widget.archived == false
                              ? Colors.red
                              : Colors.green,
                          size: 20,
                        ),
                      ),
                    ),
                    secondaryBackground: Container(
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(
                          Iconsax.trush_square,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                    child: TaskCard(taskList: taskList),
                  );
                },
              ),
      ),
    );
  }
}
