import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:todark/app/ui/tasks/view/all_tasks.dart';
import 'package:todark/app/ui/settings/view/settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todark/app/ui/tasks/widgets/tasks_action.dart';
import 'package:todark/app/ui/todos/view/calendar_todos.dart';
import 'package:todark/app/ui/todos/view/all_todos.dart';
import 'package:todark/app/ui/todos/widgets/todos_action.dart';
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

  void onSwipe(DragEndDetails details) {
    if (details.primaryVelocity! < 0) {
      if (tabIndex < 3) {
        changeTabIndex(tabIndex + 1);
      }
    } else if (details.primaryVelocity! > 0) {
      if (tabIndex > 0) {
        changeTabIndex(tabIndex - 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: tabIndex,
        children: pages,
      ),
      bottomNavigationBar: GestureDetector(
        onHorizontalDragEnd: onSwipe,
        child: NavigationBar(
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
