import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:todark/main.dart';

class Statistics extends StatefulWidget {
  const Statistics({
    super.key,
    required this.countTotalTodos,
    required this.countDoneTodos,
  });
  final int countTotalTodos;
  final int countDoneTodos;

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'taskCompleted'.tr,
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.countDoneTodos}/${widget.countTotalTodos} ${'completed'.tr}',
                    style: context.textTheme.titleSmall?.copyWith(
                      color: Colors.grey,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat.MMMMEEEEd(locale.languageCode)
                        .format(DateTime.now()),
                    style: context.textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SleekCircularSlider(
              appearance: CircularSliderAppearance(
                animationEnabled: false,
                angleRange: 360,
                startAngle: 270,
                size: 70,
                infoProperties: InfoProperties(
                  modifier: (percentage) {
                    return widget.countTotalTodos != 0
                        ? '${((widget.countDoneTodos / widget.countTotalTodos) * 100).round()}%'
                        : '0%';
                  },
                  mainLabelStyle:
                      context.textTheme.labelLarge?.copyWith(fontSize: 18),
                ),
                customColors: CustomSliderColors(
                  progressBarColors: <Color>[
                    Colors.blueAccent,
                    Colors.greenAccent,
                  ],
                  trackColor: Colors.grey[300],
                ),
                customWidths: CustomSliderWidths(
                  progressBarWidth: 7,
                  trackWidth: 3,
                  handlerSize: 0,
                  shadowWidth: 0,
                ),
              ),
              min: 0,
              max: widget.countTotalTodos != 0
                  ? widget.countTotalTodos.toDouble()
                  : 1,
              initialValue: widget.countDoneTodos.toDouble(),
            ),
          ],
        ),
      ),
    );
  }
}
