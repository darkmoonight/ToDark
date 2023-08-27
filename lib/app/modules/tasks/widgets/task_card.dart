import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/modules/todos/view/todos_task.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
  });
  final Tasks task;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListTile(
        horizontalTitleGap: 10,
        minVerticalPadding: 25,
        splashColor: Colors.transparent,
        onTap: () {
          Get.to(
            () => TodosTask(task: task),
            transition: Transition.downToUp,
          );
        },
        leading: SizedBox(
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
                  return task.todos.isNotEmpty
                      ? '${((task.todos.where((e) => e.done == true).toList().length / task.todos.length) * 100).round()}%'
                      : '0%';
                },
                mainLabelStyle: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              customColors: CustomSliderColors(
                progressBarColor: Color(task.taskColor!),
                trackColor: Colors.grey.shade300,
              ),
              customWidths: CustomSliderWidths(
                progressBarWidth: 5,
                trackWidth: 3,
                handlerSize: 0,
                shadowWidth: 0,
              ),
            ),
            min: 0,
            max: task.todos.isNotEmpty ? task.todos.length.toDouble() : 1,
            initialValue: task.todos
                .where((e) => e.done == true)
                .toList()
                .length
                .toDouble(),
          ),
        ),
        title: Text(
          task.title!,
          style: context.textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: task.description!.isNotEmpty
            ? Text(
                task.description!,
                style: context.textTheme.labelLarge?.copyWith(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              )
            : null,
      ),
    );
  }
}
