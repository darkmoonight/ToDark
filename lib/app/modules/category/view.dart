import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/select_button.dart';
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

  getCountTodos() async {
    service.countTotalTodos.value = await service.getCountTotalTodos();
    service.countDoneTodos.value = await service.getCountDoneTodos();
    setState(() {
      countTotalTodos = service.countTotalTodos.value;
      countDoneTodos = service.countDoneTodos.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            right: 20,
            left: 20,
            bottom: 30,
            top: 10,
          ),
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
                          mainLabelStyle: context.theme.textTheme.headline2
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
                        style: context.theme.textTheme.headline5,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  DateFormat.MMMMd(
                          locale.toString() == 'ru_RU' ? 'ru_RU' : 'en_US')
                      .format(
                    DateTime.now(),
                  ),
                  style: context.theme.textTheme.headline6,
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
                      left: 30, top: 20, bottom: 5, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'categories'.tr,
                            style: context.theme.textTheme.headline1?.copyWith(
                                color: context.theme.backgroundColor),
                          ),
                          Text(
                            '($countDoneTodos/$countTotalTodos) ${'completed'.tr}',
                            style: context.theme.textTheme.subtitle2,
                          ),
                        ],
                      ),
                      SelectButton(
                        icons: [
                          Icon(
                            Iconsax.archive_minus,
                            color: context.theme.scaffoldBackgroundColor,
                          ),
                          Icon(
                            Iconsax.archive_tick,
                            color: context.theme.scaffoldBackgroundColor,
                          ),
                        ],
                        onToggleCallback: (value) {
                          setState(() {
                            service.toggleValue.value = value;
                          });
                        },
                        backgroundColor: context.theme.scaffoldBackgroundColor,
                      ),
                    ],
                  ),
                ),
                TaskTypeList(
                  toggle: service.toggleValue.value,
                  set: () {
                    setState(() {});
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
