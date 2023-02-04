import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/task_type_list.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final service = IsarServices();
  final locale = Get.locale;
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  getCountTodos() async {
    final countTotal = await service.getCountTotalTodos();
    final countDone = await service.getCountDoneTodos();
    setState(() {
      countTotalTodos = countTotal;
      countDoneTodos = countDone;
    });
  }

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Iconsax.archive_tick);
        }
        return const Icon(Iconsax.archive_minus);
      },
    );

    return Column(
      children: [
        Container(
          margin:
              const EdgeInsets.only(right: 20, left: 20, bottom: 30, top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Row(
                  children: [
                    SleekCircularSlider(
                      appearance: CircularSliderAppearance(
                        animationEnabled: false,
                        angleRange: 360,
                        startAngle: 270,
                        size: 110,
                        infoProperties: InfoProperties(
                          modifier: (percentage) {
                            return countTotalTodos != 0
                                ? '${((countDoneTodos / countTotalTodos) * 100).round()}%'
                                : '0%';
                          },
                          mainLabelStyle: context.theme.textTheme.titleLarge
                              ?.copyWith(color: Colors.white),
                        ),
                        customColors: CustomSliderColors(
                          progressBarColors: <Color>[
                            Colors.blueAccent,
                            Colors.greenAccent,
                          ],
                          trackColor: Colors.white,
                        ),
                        customWidths: CustomSliderWidths(
                          progressBarWidth: 7,
                          trackWidth: 3,
                          handlerSize: 0,
                          shadowWidth: 0,
                        ),
                      ),
                      min: 0,
                      max:
                          countTotalTodos != 0 ? countTotalTodos.toDouble() : 1,
                      initialValue: countDoneTodos.toDouble(),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Text(
                        'taskCompleted'.tr,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat.MMMMd('${locale?.languageCode}').format(
                    DateTime.now(),
                  ),
                  style: context.theme.textTheme.titleSmall
                      ?.copyWith(color: Colors.white),
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
                            'categories'.tr,
                            style: context.theme.textTheme.titleLarge?.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '($countDoneTodos/$countTotalTodos) ${'completed'.tr}',
                            style: context.theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        trackColor: service.trackColor,
                        thumbIcon: thumbIcon,
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
                TaskTypeList(
                  toggle: service.toggleValue.value,
                  set: () {
                    getCountTodos();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
