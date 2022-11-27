import 'package:todark/app/data/schema.dart';
import 'package:todark/app/widgets/select_button.dart';
import 'package:todark/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:isar/isar.dart';

import '../../widgets/todos_list.dart';

class AllTask extends StatefulWidget {
  const AllTask({super.key});

  @override
  State<AllTask> createState() => _AllTaskState();
}

class _AllTaskState extends State<AllTask> {
  var todos = <Todos>[];
  bool isLoaded = false;
  int toggleValue = 0;
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  initState() {
    getTodo();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  getTodo() async {
    final todosCollection = isar.todos;
    List<Todos> getTodos;
    toggleValue == 0
        ? getTodos = await todosCollection
            .filter()
            .doneEqualTo(false)
            .task((q) => q.archiveEqualTo(false))
            .findAll()
        : getTodos = await todosCollection
            .filter()
            .doneEqualTo(true)
            .task((q) => q.archiveEqualTo(false))
            .findAll();
    countTotalTodos = await getCountTotalTodos();
    countDoneTodos = await getCountDoneTodos();
    toggleValue;
    setState(() {
      todos = getTodos;
      isLoaded = true;
    });
  }

  getCountTotalTodos() async {
    int res;
    final todosCollection = isar.todos;
    List<Todos> getTodos;
    getTodos = await todosCollection
        .filter()
        .task((q) => q.archiveEqualTo(false))
        .findAll();
    res = getTodos.length;
    return res;
  }

  getCountDoneTodos() async {
    int res;
    final todosCollection = isar.todos;
    List<Todos> getTodos;
    getTodos = await todosCollection
        .filter()
        .doneEqualTo(true)
        .task((q) => q.archiveEqualTo(false))
        .findAll();
    res = getTodos.length;
    return res;
  }

  deleteTodo(Todos todos) async {
    await isar.writeTxn(() async {
      await isar.todos.delete(todos.id);
      if (todos.todoCompletedTime != null) {
        await flutterLocalNotificationsPlugin.cancel(todos.id);
      }
    });
    EasyLoading.showSuccess('taskDelete'.tr,
        duration: const Duration(milliseconds: 500));
    getTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
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
            padding:
                const EdgeInsets.only(left: 30, top: 20, bottom: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'allTasks'.tr,
                      style: context.theme.textTheme.headline1
                          ?.copyWith(color: context.theme.backgroundColor),
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
                      Iconsax.close_circle,
                      color: context.theme.scaffoldBackgroundColor,
                    ),
                    Icon(
                      Iconsax.tick_circle,
                      color: context.theme.scaffoldBackgroundColor,
                    ),
                  ],
                  onToggleCallback: (value) {
                    setState(() {
                      toggleValue = value;
                    });
                    getTodo();
                  },
                  backgroundColor: context.theme.scaffoldBackgroundColor,
                ),
              ],
            ),
          ),
          TodosList(
            toggleValue: toggleValue,
            isAllTask: true,
            isCalendare: false,
            isLoaded: isLoaded,
            todos: todos,
            deleteTodo: deleteTodo,
            getTodo: getTodo,
          )
        ],
      ),
    );
  }
}
