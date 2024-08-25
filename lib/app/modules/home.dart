import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:todark/app/modules/tasks/view/all_tasks.dart';
import 'package:todark/app/modules/settings/view/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todark/app/modules/tasks/widgets/tasks_action.dart';
import 'package:todark/app/modules/todos/view/calendar_todos.dart';
import 'package:todark/app/modules/todos/view/all_todos.dart';
import 'package:todark/app/modules/todos/widgets/todos_action.dart';
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
    AllTasks(),
    AllTodos(),
    CalendarTodos(),
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
      body: IndexedStack(
        index: tabIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) => changeTabIndex(index),
        selectedIndex: tabIndex,
        destinations: [
          NavigationDestination(
            icon: const Icon(IconsaxPlusLinear.folder_2),
            selectedIcon: const Icon(IconsaxPlusBold.folder_2),
            label: 'categories'.tr,
          ),
          NavigationDestination(
            icon: const Icon(IconsaxPlusLinear.task_square),
            selectedIcon: const Icon(IconsaxPlusBold.task_square),
            label: 'allTodos'.tr,
          ),
          NavigationDestination(
            icon: const Icon(IconsaxPlusLinear.calendar),
            selectedIcon: const Icon(IconsaxPlusBold.calendar),
            label: 'calendar'.tr,
          ),
          NavigationDestination(
            icon: const Icon(IconsaxPlusLinear.category),
            selectedIcon: const Icon(IconsaxPlusBold.category),
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
                        ? TasksAction(
                            text: 'create'.tr,
                            edit: false,
                          )
                        : TodosAction(
                            text: 'create'.tr,
                            edit: false,
                            category: true,
                          );
                  },
                );
              },
              child: const Icon(IconsaxPlusLinear.add),
            ),
    );
  }
}
