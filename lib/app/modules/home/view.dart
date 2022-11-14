import 'package:dark_todo/app/modules/tasks/view.dart';
import 'package:dark_todo/app/widgets/select_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int toggleValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        CircularStepProgressIndicator(
                          totalSteps: 2,
                          currentStep: 1,
                          stepSize: 4,
                          selectedColor: Colors.green,
                          unselectedColor: Colors.white,
                          padding: 0,
                          selectedStepSize: 6,
                          roundedCap: (_, __) => true,
                          child: Center(
                            child: Text(
                              '50%',
                              style: context.theme.textTheme.headline2,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            'Задач\nВыполнено',
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
                      DateFormat.MMMMd('ru').format(
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
                  color: Color.fromARGB(255, 245, 245, 245),
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
                          left: 30, top: 20, bottom: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Задачи',
                                style: context.theme.textTheme.headline1
                                    ?.copyWith(
                                        color: context.theme.backgroundColor),
                              ),
                              Text(
                                '(1/2) Завершено',
                                style: context.theme.textTheme.subtitle2,
                              ),
                            ],
                          ),
                          SelectButton(
                            icons: const [
                              Icon(
                                Iconsax.close_circle,
                                color: Colors.black,
                              ),
                              Icon(
                                Iconsax.tick_circle,
                                color: Colors.black,
                              ),
                            ],
                            onToggleCallback: (value) {
                              setState(() {
                                toggleValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 7,
                        itemBuilder: (BuildContext context, int index) {
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
                                  Get.to(() => const TaskPage(),
                                      transition: Transition.downToUp);
                                },
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                            width: 60,
                                            child:
                                                CircularStepProgressIndicator(
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
                                                  style: context
                                                      .theme.textTheme.headline6
                                                      ?.copyWith(
                                                          color: Colors.black),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Comrun',
                                                  style: context
                                                      .theme.textTheme.headline4
                                                      ?.copyWith(
                                                          color: Colors.black),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 5),
                                                Text(
                                                  'Раннер про компьютер',
                                                  style: context.theme.textTheme
                                                      .subtitle2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      DateFormat.yMd('ru')
                                          .format(DateTime.now()),
                                      style: context.theme.textTheme.subtitle2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
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
        onPressed: () {},
        elevation: 0,
        backgroundColor: context.theme.primaryColor,
        child: const Icon(
          Iconsax.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
