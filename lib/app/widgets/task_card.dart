import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/modules/tasks.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskList,
  });
  final Tasks taskList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Get.to(
              () => TaskPage(
                task: widget.taskList,
              ),
              transition: Transition.downToUp,
            );
          },
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
                        return widget.taskList.todos.isNotEmpty
                            ? '${((widget.taskList.todos.where((e) => e.done == true).toList().length / widget.taskList.todos.length) * 100).round()}%'
                            : '0%';
                      },
                      mainLabelStyle: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    customColors: CustomSliderColors(
                      progressBarColors: <Color>[
                        Color(widget.taskList.taskColor!),
                        Color(widget.taskList.taskColor!).withOpacity(0.9),
                        Color(widget.taskList.taskColor!).withOpacity(0.8),
                      ],
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
                  max: widget.taskList.todos.isNotEmpty
                      ? widget.taskList.todos.length.toDouble()
                      : 1,
                  initialValue: widget.taskList.todos
                      .where((e) => e.done == true)
                      .toList()
                      .length
                      .toDouble(),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskList.title!,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.visible,
                    ),
                    widget.taskList.description!.isNotEmpty
                        ? Text(
                            widget.taskList.description!,
                            style: context.textTheme.labelLarge?.copyWith(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.visible,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
