import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:todark/app/data/schema.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/services/controller.dart';
import '../modules/tasks.dart';

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
                              widget.archived == false
                                  ? 'addCategory'.tr
                                  : 'addArchive'.tr,
                              textAlign: TextAlign.center,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                () => TaskPage(
                                  task: taskList,
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
                                        child: SleekCircularSlider(
                                          appearance: CircularSliderAppearance(
                                            animationEnabled: false,
                                            angleRange: 360,
                                            startAngle: 270,
                                            size: 110,
                                            infoProperties: InfoProperties(
                                              modifier: (percentage) {
                                                return taskList.todos.isNotEmpty
                                                    ? '${((taskList.todos.where((e) => e.done == true).toList().length / taskList.todos.length) * 100).round()}%'
                                                    : '0%';
                                              },
                                              mainLabelStyle: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            customColors: CustomSliderColors(
                                              progressBarColors: <Color>[
                                                Color(taskList.taskColor!),
                                                Color(taskList.taskColor!)
                                                    .withOpacity(0.9),
                                                Color(taskList.taskColor!)
                                                    .withOpacity(0.8),
                                              ],
                                              trackColor: Colors.grey[300],
                                            ),
                                            customWidths: CustomSliderWidths(
                                              progressBarWidth: 5,
                                              trackWidth: 3,
                                              handlerSize: 0,
                                              shadowWidth: 0,
                                            ),
                                          ),
                                          min: 0,
                                          max: taskList.todos.isNotEmpty
                                              ? taskList.todos.length.toDouble()
                                              : 1,
                                          initialValue: taskList.todos
                                              .where((e) => e.done == true)
                                              .toList()
                                              .length
                                              .toDouble(),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              taskList.title!,
                                              style: context
                                                  .textTheme.titleLarge
                                                  ?.copyWith(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.visible,
                                            ),
                                            taskList.description!.isNotEmpty
                                                ? Text(
                                                    taskList.description!,
                                                    style: context
                                                        .textTheme.bodyLarge
                                                        ?.copyWith(
                                                      color: Colors.grey[700],
                                                    ),
                                                    overflow:
                                                        TextOverflow.visible,
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${taskList.todos.where((e) => e.done == true).toList().length}/${taskList.todos.length}',
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
