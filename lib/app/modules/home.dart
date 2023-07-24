import 'package:todark/app/modules/all_tasks.dart';
import 'package:todark/app/modules/calendar.dart';
import 'package:todark/app/modules/category.dart';
import 'package:todark/app/modules/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/widgets/task_type_cu.dart';
import 'package:todark/app/widgets/todos_ce.dart';
import 'package:todark/theme/theme_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final themeController = Get.put(ThemeController());
  int tabIndex = 0;

  final pages = const [
    CategoryPage(),
    AllTaskPage(),
    CalendarPage(),
    SettingsPage(),
  ];

  void changeTabIndex(int index) {
    setState(() {
      tabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tabIndex == 0
              ? 'categories'.tr
              : tabIndex == 1
                  ? 'allTasks'.tr
                  : tabIndex == 2
                      ? 'calendar'.tr
                      : 'settings'.tr,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: tabIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) => changeTabIndex(index),
        selectedIndex: tabIndex,
        destinations: [
          NavigationDestination(
            icon: const Icon(Iconsax.folder_2),
            selectedIcon: const Icon(Iconsax.folder_25),
            label: 'categories'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Iconsax.task_square),
            selectedIcon: const Icon(Iconsax.task_square5),
            label: 'allTasks'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Iconsax.calendar_1),
            selectedIcon: const Icon(Iconsax.calendar5),
            label: 'calendar'.tr,
          ),
          NavigationDestination(
            icon: const Icon(Iconsax.category),
            selectedIcon: const Icon(Iconsax.category5),
            label: 'settings'.tr,
          ),
        ],
      ),
      floatingActionButton: tabIndex == 3
          ? null
          : FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  enableDrag: false,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return tabIndex == 0
                        ? TaskTypeCu(
                            text: 'create'.tr,
                            edit: false,
                          )
                        : TodosCe(
                            text: 'create'.tr,
                            edit: false,
                            category: true,
                          );
                  },
                );
              },
              child: const Icon(Iconsax.add),
            ),
    );
  }
}
