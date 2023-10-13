import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/controller/controller.dart';
import 'package:todark/app/data/schema.dart';
import 'package:todark/app/modules/tasks/widgets/task_card.dart';
import 'package:todark/app/modules/todos/view/todos_task.dart';
import 'package:todark/app/widgets/list_empty.dart';
import 'package:todark/app/widgets/my_delegate.dart';
import 'package:todark/app/modules/tasks/widgets/statistics.dart';
import 'package:todark/app/widgets/text_form.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks>
    with SingleTickerProviderStateMixin {
  final todoController = Get.put(TodoController());
  late TabController tabController;
  TextEditingController searchTasks = TextEditingController();
  String filter = '';

  List<Tasks> selectedItem = [];
  bool isMultiSelectionEnabled = false;

  applyFilter(String value) async {
    filter = value.toLowerCase();
    setState(() {});
  }

  void doMultiSelection(Tasks tasks) {
    if (isMultiSelectionEnabled) {
      if (selectedItem.contains(tasks)) {
        selectedItem.remove(tasks);
      } else {
        selectedItem.add(tasks);
      }
      setState(() {});
    } else {
      //Other logic
    }
  }

  @override
  void initState() {
    super.initState();
    applyFilter('');
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: isMultiSelectionEnabled
            ? IconButton(
                onPressed: () {
                  selectedItem.clear();
                  isMultiSelectionEnabled = false;
                  setState(() {});
                },
                icon: const Icon(
                  Iconsax.close_square,
                  size: 20,
                ),
              )
            : null,
        title: Text(
          'categories'.tr,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Visibility(
            visible: selectedItem.isNotEmpty,
            child: IconButton(
              icon: const Icon(
                Iconsax.trush_square,
                size: 20,
              ),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'deleteCategory'.tr,
                        style: context.textTheme.titleLarge,
                      ),
                      content: Text(
                        'deleteCategoryQuery'.tr,
                        style: context.textTheme.titleMedium,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Get.back(),
                            child: Text('cancel'.tr,
                                style: context.textTheme.titleMedium
                                    ?.copyWith(color: Colors.blueAccent))),
                        TextButton(
                            onPressed: () {
                              todoController.deleteTask(selectedItem);
                              selectedItem.clear();
                              setState(() {});
                              Get.back();
                            },
                            child: Text('delete'.tr,
                                style: context.textTheme.titleMedium
                                    ?.copyWith(color: Colors.red))),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Visibility(
            visible: selectedItem.isNotEmpty,
            child: IconButton(
              icon: Icon(
                tabController.index == 0
                    ? Iconsax.archive_add
                    : Iconsax.refresh_left_square,
                size: 20,
              ),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        tabController.index == 0
                            ? 'archiveCategory'.tr
                            : 'noArchiveCategory'.tr,
                        style: context.textTheme.titleLarge,
                      ),
                      content: Text(
                        tabController.index == 0
                            ? 'archiveCategoryQuery'.tr
                            : 'noArchiveCategoryQuery'.tr,
                        style: context.textTheme.titleMedium,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Get.back(),
                            child: Text('cancel'.tr,
                                style: context.textTheme.titleMedium
                                    ?.copyWith(color: Colors.blueAccent))),
                        TextButton(
                            onPressed: () {
                              if (tabController.index == 0) {
                                todoController.archiveTask(selectedItem);
                              } else {
                                todoController.noArchiveTask(selectedItem);
                              }
                              selectedItem.clear();

                              setState(() {});
                              Get.back();
                            },
                            child: Text(
                                tabController.index == 0
                                    ? 'archive'.tr
                                    : 'noArchive'.tr,
                                style: context.textTheme.titleMedium
                                    ?.copyWith(color: Colors.red))),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    MyTextForm(
                      labelText: 'searchCategory'.tr,
                      type: TextInputType.text,
                      icon: const Icon(
                        Iconsax.search_normal_1,
                        size: 20,
                      ),
                      controller: searchTasks,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      onChanged: applyFilter,
                      iconButton: searchTasks.text.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                searchTasks.clear();
                                applyFilter('');
                              },
                              icon: const Icon(
                                Iconsax.close_circle,
                                color: Colors.grey,
                                size: 20,
                              ),
                            )
                          : null,
                    ),
                    Obx(
                      () {
                        var createdTodos = todoController.createdAllTodos();
                        var completedTodos = todoController.completedAllTodos();
                        var precent = (completedTodos / createdTodos * 100)
                            .toStringAsFixed(0);
                        return Statistics(
                          createdTodos: createdTodos,
                          completedTodos: completedTodos,
                          precent: precent,
                        );
                      },
                    ),
                  ],
                ),
              ),
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  delegate: MyDelegate(
                    TabBar(
                      controller: tabController,
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          return Colors.transparent;
                        },
                      ),
                      tabs: [
                        Tab(text: 'active'.tr),
                        Tab(text: 'archived'.tr),
                      ],
                    ),
                  ),
                  floating: true,
                  pinned: true,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: tabController,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Obx(
                  () {
                    var tasks = todoController.tasks
                        .where((task) =>
                            task.archive == false &&
                            (filter.isEmpty ||
                                task.title.toLowerCase().contains(filter)))
                        .toList()
                        .obs;
                    return tasks.isEmpty
                        ? ListEmpty(
                            img: 'assets/images/Category.png',
                            text: 'addCategory'.tr,
                          )
                        : ListView(
                            children: [
                              ...tasks.map(
                                (taskList) {
                                  var createdTodos = todoController
                                      .createdAllTodosTask(taskList);
                                  var completedTodos = todoController
                                      .completedAllTodosTask(taskList);
                                  var precent =
                                      (completedTodos / createdTodos * 100)
                                          .toStringAsFixed(0);
                                  return TaskCard(
                                    key: ValueKey(taskList),
                                    task: taskList,
                                    createdTodos: createdTodos,
                                    completedTodos: completedTodos,
                                    precent: precent,
                                    isMultiSelectionEnabled:
                                        isMultiSelectionEnabled,
                                    selectedItem: selectedItem,
                                    onTap: () {
                                      if (isMultiSelectionEnabled) {
                                        doMultiSelection(taskList);
                                      } else {
                                        Get.to(
                                          () => TodosTask(task: taskList),
                                          transition: Transition.downToUp,
                                        );
                                      }
                                    },
                                    onLongPress: () {
                                      isMultiSelectionEnabled = true;
                                      doMultiSelection(taskList);
                                    },
                                  );
                                },
                              ).toList(),
                            ],
                          );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Obx(
                  () {
                    var tasks = todoController.tasks
                        .where((task) =>
                            task.archive == true &&
                            (filter.isEmpty ||
                                task.title.toLowerCase().contains(filter)))
                        .toList()
                        .obs;
                    return tasks.isEmpty
                        ? ListEmpty(
                            img: 'assets/images/Category.png',
                            text: 'addArchiveCategory'.tr,
                          )
                        : ListView(
                            children: [
                              ...tasks.map(
                                (taskList) {
                                  var createdTodos = todoController
                                      .createdAllTodosTask(taskList);
                                  var completedTodos = todoController
                                      .completedAllTodosTask(taskList);
                                  var precent =
                                      (completedTodos / createdTodos * 100)
                                          .toStringAsFixed(0);
                                  return TaskCard(
                                    key: ValueKey(taskList),
                                    task: taskList,
                                    createdTodos: createdTodos,
                                    completedTodos: completedTodos,
                                    precent: precent,
                                    isMultiSelectionEnabled:
                                        isMultiSelectionEnabled,
                                    selectedItem: selectedItem,
                                    onTap: () {
                                      if (isMultiSelectionEnabled) {
                                        doMultiSelection(taskList);
                                      } else {
                                        Get.to(
                                          () => TodosTask(task: taskList),
                                          transition: Transition.downToUp,
                                        );
                                      }
                                    },
                                    onLongPress: () {
                                      isMultiSelectionEnabled = true;
                                      doMultiSelection(taskList);
                                    },
                                  );
                                },
                              ).toList(),
                            ],
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
