import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:todark/app/data/schema.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/services/isar_service.dart';

import '../modules/tasks.dart';

class TaskTypeList extends StatefulWidget {
  const TaskTypeList({
    super.key,
    required this.toggle,
    required this.set,
  });
  final bool toggle;
  final Function() set;

  @override
  State<TaskTypeList> createState() => _TaskTypeListState();
}

class _TaskTypeListState extends State<TaskTypeList> {
  final service = IsarServices();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<List<Tasks>>(
        stream: service.getTask(widget.toggle),
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
                              widget.toggle == false
                                  ? 'addCategory'.tr
                                  : 'addArchive'.tr,
                              textAlign: TextAlign.center,
                              style:
                                  context.theme.textTheme.titleMedium?.copyWith(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
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
                              backgroundColor:
                                  context.theme.colorScheme.primaryContainer,
                              title: Text(
                                direction == DismissDirection.endToStart
                                    ? "deleteCategory".tr
                                    : widget.toggle == false
                                        ? "archiveTask".tr
                                        : "noArchiveTask".tr,
                                style: context.theme.textTheme.titleLarge,
                              ),
                              content: Text(
                                  direction == DismissDirection.endToStart
                                      ? "deleteCategoryQuery".tr
                                      : widget.toggle == false
                                          ? "archiveTaskQuery".tr
                                          : "noArchiveTaskQuery".tr,
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
                                    child: Text(
                                        direction == DismissDirection.endToStart
                                            ? "delete".tr
                                            : widget.toggle == false
                                                ? "archive".tr
                                                : "noArchive".tr,
                                        style: context
                                            .theme.textTheme.titleMedium
                                            ?.copyWith(color: Colors.red))),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (DismissDirection direction) {
                        if (direction == DismissDirection.endToStart) {
                          service.deleteTask(taskList, widget.set);
                        } else if (direction == DismissDirection.startToEnd) {
                          widget.toggle == false
                              ? service.archiveTask(taskList, widget.set)
                              : service.noArchiveTask(taskList, widget.set);
                        }
                      },
                      background: Container(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: Icon(
                            widget.toggle == false
                                ? Iconsax.archive_2
                                : Iconsax.refresh_left_square,
                            color: widget.toggle == false
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
                      child: Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                          left: 25,
                          right: 25,
                        ),
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => TaskPage(
                                task: taskList,
                                set: widget.set,
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
                                                .theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          customColors: CustomSliderColors(
                                            progressBarColors: <Color>[
                                              Color(taskList.taskColor),
                                              Color(taskList.taskColor)
                                                  .withOpacity(0.9),
                                              Color(taskList.taskColor)
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
                                            taskList.title,
                                            style: context
                                                .theme.textTheme.titleLarge
                                                ?.copyWith(
                                              color: Get.isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.visible,
                                          ),
                                          taskList.description.isNotEmpty
                                              ? Text(
                                                  taskList.description,
                                                  style: context
                                                      .theme.textTheme.bodyLarge
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
                                style:
                                    context.theme.textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
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
