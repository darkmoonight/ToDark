import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/controller/controller.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/modules/tasks/widgets/task_card.dart';
import 'package:todark/app/widgets/list_empty.dart';
import 'package:todark/main.dart';

class TasksList extends StatefulWidget {
  const TasksList({
    super.key,
    required this.archived,
  });
  final bool archived;

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  final todoController = Get.put(TodoController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Obx(
        () {
          var tasks = todoController.tasks
              .where((task) => task.archive == widget.archived)
              .toList()
              .obs;
          return tasks.isEmpty
              ? ListEmpty(
                  img: 'assets/images/Category.png',
                  text: widget.archived ? 'addArchive'.tr : 'addCategory'.tr,
                )
              : ReorderableListView(
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final items = tasks.removeAt(oldIndex);
                    tasks.insert(newIndex, items);

                    for (int i = 0; i < tasks.length; i++) {
                      final item = tasks[i];
                      item.index = i;
                      isar.writeTxn(() async => await isar.tasks.put(item));
                    }
                  },
                  children: [
                    ...tasks.map(
                      (taskList) {
                        var createdTodos =
                            todoController.createdAllTodosTask(taskList);
                        var completedTodos =
                            todoController.completedAllTodosTask(taskList);
                        var precent = (completedTodos / createdTodos * 100)
                            .toStringAsFixed(0);
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
                                        : widget.archived
                                            ? 'noArchiveTask'.tr
                                            : 'archiveTask'.tr,
                                    style: context.textTheme.titleLarge,
                                  ),
                                  content: Text(
                                    direction == DismissDirection.endToStart
                                        ? 'deleteCategoryQuery'.tr
                                        : widget.archived
                                            ? 'noArchiveTaskQuery'.tr
                                            : 'archiveTaskQuery'.tr,
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
                                        child: Text(
                                            direction ==
                                                    DismissDirection.endToStart
                                                ? 'delete'.tr
                                                : widget.archived
                                                    ? 'noArchive'.tr
                                                    : 'archive'.tr,
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
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                              widget.archived
                                  ? todoController.noArchiveTask(taskList)
                                  : todoController.archiveTask(taskList);
                            }
                          },
                          background: Container(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Icon(
                                widget.archived
                                    ? Iconsax.refresh_left_square
                                    : Iconsax.archive_2,
                                color:
                                    widget.archived ? Colors.green : Colors.red,
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
                          child: TaskCard(
                            task: taskList,
                            createdTodos: createdTodos,
                            completedTodos: completedTodos,
                            precent: precent,
                          ),
                        );
                      },
                    ).toList(),
                  ],
                );
        },
      ),
    );
  }
}
