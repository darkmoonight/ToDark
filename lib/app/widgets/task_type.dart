import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../modules/tasks/view.dart';

class TaskType extends StatelessWidget {
  const TaskType({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const ObjectKey(1),
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) {},
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
          onPressed: () {
            Get.to(() => const TaskPage(), transition: Transition.downToUp);
          },
          child: Row(
            children: [
              Flexible(
                child: Row(
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: CircularStepProgressIndicator(
                        totalSteps: 4,
                        currentStep: 1,
                        stepSize: 4,
                        selectedColor: Colors.blueAccent,
                        unselectedColor: Colors.grey[300],
                        padding: 0,
                        selectedStepSize: 6,
                        roundedCap: (_, __) => true,
                        child: Center(
                          child: Text(
                            '25%',
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
                            'Comrun',
                            style: context.theme.textTheme.headline4
                                ?.copyWith(color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Раннер про компьютер',
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
                DateFormat.yMd('ru').format(DateTime.now()),
                style: context.theme.textTheme.subtitle2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
