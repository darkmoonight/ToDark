import 'package:todark/app/data/schema.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/task_type_cu.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:todark/app/widgets/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({
    super.key,
    required this.task,
    required this.set,
  });
  final Tasks task;
  final Function() set;

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final service = IsarServices();
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    super.initState();
  }

  getCountTodos() async {
    final countTotal = await service.getCountTotalTodosTask(widget.task);
    final countDone = await service.getCountDoneTodosTask(widget.task);
    setState(() {
      countTotalTodos = countTotal;
      countDoneTodos = countDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.set();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              widget.set();
                              Get.back();
                            },
                            icon: const Icon(
                              Iconsax.arrow_left_1,
                              color: Colors.white,
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          Expanded(
                            child: widget.task.description.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.task.title,
                                        style: context
                                            .theme.textTheme.headlineSmall
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        widget.task.description,
                                        style: context.theme.textTheme.bodyLarge
                                            ?.copyWith(
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  )
                                : Text(
                                    widget.task.title,
                                    style: context.theme.textTheme.headlineSmall
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                          IconButton(
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
                                  return TaskTypeCu(
                                    text: 'editing'.tr,
                                    edit: true,
                                    task: widget.task,
                                    set: () {
                                      setState(() {});
                                    },
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Iconsax.edit,
                              color: Colors.white,
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: Get.size.width,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, top: 10, bottom: 5, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'tasks'.tr,
                                  style: context.theme.textTheme.titleLarge
                                      ?.copyWith(
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '($countDoneTodos/$countTotalTodos) ${'completed'.tr}',
                                  style: context.theme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              trackColor: service.trackColor,
                              thumbIcon: service.thumbIcon,
                              value: service.toggleValue.value,
                              onChanged: (value) {
                                setState(() {
                                  service.toggleValue.value = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TodosList(
                          allTask: false,
                          calendare: false,
                          toggle: service.toggleValue.value,
                          task: widget.task,
                          set: () {
                            getCountTodos();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              enableDrag: false,
              backgroundColor: context.theme.scaffoldBackgroundColor,
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return TodosCe(
                  text: 'create'.tr,
                  edit: false,
                  task: widget.task,
                  category: false,
                  set: () {
                    getCountTodos();
                  },
                );
              },
            );
          },
          elevation: 0,
          backgroundColor: context.theme.colorScheme.primaryContainer,
          child: const Icon(
            Iconsax.add,
            color: Colors.greenAccent,
          ),
        ),
      ),
    );
  }
}
