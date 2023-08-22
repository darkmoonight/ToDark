import 'package:todark/app/data/schema.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/services/controller.dart';
import 'package:todark/app/widgets/task_card.dart';

class TaskTypeList extends StatefulWidget {
  const TaskTypeList({
    super.key,
    required this.archived,
  });
  final bool archived;

  @override
  State<TaskTypeList> createState() => _TaskTypeListState();
}

class _TaskTypeListState extends State<TaskTypeList> {
  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: StreamBuilder<List<Tasks>>(
        stream: todoController.getTask(widget.archived),
        builder: (BuildContext context, AsyncSnapshot<List<Tasks>> listData) {
          switch (listData.connectionState) {
            case ConnectionState.done:
            default:
              if (listData.hasData) {
                final task = listData.data!;
                if (task.isEmpty) {
                  return Center(
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
                  );
                }
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: task.length,
                  itemBuilder: (BuildContext context, int index) {
                    final taskList = task[index];
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
                                    ? "deleteCategory".tr
                                    : widget.archived == false
                                        ? "archiveTask".tr
                                        : "noArchiveTask".tr,
                                style: context.textTheme.titleLarge,
                              ),
                              content: Text(
                                direction == DismissDirection.endToStart
                                    ? "deleteCategoryQuery".tr
                                    : widget.archived == false
                                        ? "archiveTaskQuery".tr
                                        : "noArchiveTaskQuery".tr,
                                style: context.textTheme.titleMedium,
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Get.back(result: false),
                                    child: Text("cancel".tr,
                                        style: context.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Colors.blueAccent))),
                                TextButton(
                                    onPressed: () => Get.back(result: true),
                                    child: Text(
                                        direction == DismissDirection.endToStart
                                            ? "delete".tr
                                            : widget.archived == false
                                                ? "archive".tr
                                                : "noArchive".tr,
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
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: Icon(
                            widget.archived == false
                                ? Iconsax.archive_2
                                : Iconsax.refresh_left_square,
                            color: widget.archived == false
                                ? Colors.red
                                : Colors.green,
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
                      child: TaskCard(
                        taskList: taskList,
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
          }
        },
      ),
    );
  }
}
