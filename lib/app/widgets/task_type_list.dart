import 'package:dark_todo/app/data/schema.dart';
import 'package:dark_todo/app/widgets/task_type.dart';
import 'package:dark_todo/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modules/tasks/view.dart';

class TaskTypeList<T extends Tasks> extends StatefulWidget {
  const TaskTypeList({
    super.key,
    required this.data,
    required this.isLoaded,
  });
  final List<T> data;
  final bool isLoaded;

  @override
  State<TaskTypeList<T>> createState() => _TaskTypeListState<T>();
}

class _TaskTypeListState<T extends Tasks> extends State<TaskTypeList<T>> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Visibility(
        visible: widget.isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child: Visibility(
          visible: widget.data.isNotEmpty,
          replacement: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/AddTasks.png',
                    scale: 5,
                  ),
                  Text(
                    'Добавьте категорию',
                    style: context.theme.textTheme.headline4?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              final T task = widget.data[index];
              return TaskType(
                element: ObjectKey(task),
                onDismissed: (DismissDirection direction) async {
                  await isar.writeTxn(() async {
                    await isar.tasks.delete(task.id);
                  });
                },
                onPressedTask: () {
                  Get.to(
                    () => const TaskPage(),
                    transition: Transition.downToUp,
                  );
                },
                totalSteps: 4,
                currentStep: 1,
                textIndicator: '25%',
                taskName: task.title,
                taskDesc: task.description,
                taskDateCreate: task.taskCreate,
                colorIndicator: Color(task.taskColor),
              );
            },
          ),
        ),
      ),
    );
  }
}
