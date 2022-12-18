import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:todark/app/modules/all_tasks.dart';
import 'package:todark/app/modules/calendar.dart';
import 'package:todark/app/modules/category.dart';
import 'package:todark/app/services/isar_service.dart';
import 'package:todark/app/widgets/task_type_cu.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final service = IsarServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 30,
        title: Row(
          children: [
            Image.asset(
              'assets/icons/icons.png',
              scale: 13,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              'ToDark',
              style: context.theme.textTheme.headline1,
            ),
          ],
        ),
      ),
      body: Obx(
        (() => IndexedStack(
              index: service.tabIndex.value,
              children: [
                CategoryPage(key: UniqueKey()),
                AllTaskPage(key: UniqueKey()),
                CalendarPage(key: UniqueKey()),
              ],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          service.tabIndex.value == 0
              ? showModalBottomSheet(
                  enableDrag: false,
                  backgroundColor: context.theme.scaffoldBackgroundColor,
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return TaskTypeCu(
                      text: 'create'.tr,
                      edit: false,
                    );
                  },
                )
              : showModalBottomSheet(
                  enableDrag: false,
                  backgroundColor: context.theme.scaffoldBackgroundColor,
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (BuildContext context) {
                    return TodosCe(
                      text: "create".tr,
                      edit: false,
                      category: true,
                      set: () {
                        setState(() {});
                      },
                    );
                  },
                );
        },
        backgroundColor: context.theme.primaryColor,
        child: const Icon(
          Iconsax.add,
          color: Colors.greenAccent,
        ),
      ),
      bottomNavigationBar: Obx(
        () => Theme(
          data: context.theme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: CustomNavigationBar(
            backgroundColor: Colors.white,
            strokeColor: const Color(0x300c18fb),
            onTap: (int index) => service.changeTabIndex(index),
            currentIndex: service.tabIndex.value,
            iconSize: 24,
            elevation: 0,
            items: [
              CustomNavigationBarItem(icon: const Icon(Iconsax.folder_2)),
              CustomNavigationBarItem(icon: const Icon(Iconsax.task_square)),
              CustomNavigationBarItem(icon: const Icon(Iconsax.calendar_1)),
            ],
          ),
        ),
      ),
    );
  }
}
