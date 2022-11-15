import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TaskType extends StatelessWidget {
  const TaskType({
    super.key,
    required this.onDismissed,
    required this.onPressedTask,
    required this.totalSteps,
    required this.currentStep,
    required this.textIndicator,
    required this.taskName,
    required this.taskDesc,
    required this.taskDateCreate,
    required this.colorIndicator,
    required this.element,
  });
  final Function(DismissDirection) onDismissed;
  final Function() onPressedTask;
  final int totalSteps;
  final int currentStep;
  final Object element;
  final String textIndicator;
  final String taskName;
  final String taskDesc;
  final String taskDateCreate;
  final Color colorIndicator;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ObjectKey(element),
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      background: Container(
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
          bottom: 20,
          left: 25,
          right: 25,
        ),
        child: CupertinoButton(
          minSize: double.minPositive,
          padding: EdgeInsets.zero,
          onPressed: onPressedTask,
          child: Row(
            children: [
              Flexible(
                child: Row(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularStepProgressIndicator(
                        totalSteps: totalSteps,
                        currentStep: currentStep,
                        stepSize: 4,
                        selectedColor: colorIndicator,
                        unselectedColor: Colors.grey[300],
                        padding: 0,
                        selectedStepSize: 6,
                        roundedCap: (_, __) => true,
                        child: Center(
                          child: Text(
                            textIndicator,
                            style: context.theme.textTheme.headline6
                                ?.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            taskName,
                            style: context.theme.textTheme.headline4
                                ?.copyWith(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            taskDesc,
                            style: context.theme.textTheme.subtitle2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                taskDateCreate,
                style: context.theme.textTheme.subtitle2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
