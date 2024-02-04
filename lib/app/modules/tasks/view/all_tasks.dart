import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/controller/todo_controller.dart';
import 'package:todark/app/modules/tasks/widgets/task_list.dart';
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

  applyFilter(String value) async {
    filter = value.toLowerCase();
    setState(() {});
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
    return Obx(
      () {
        var createdTodos = todoController.createdAllTodos();
        var completedTodos = todoController.completedAllTodos();
        var precent = (completedTodos / createdTodos * 100).toStringAsFixed(0);

        return PopScope(
          canPop: todoController.isPop.value,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }

            if (todoController.isMultiSelectionTask.isTrue) {
              todoController.doMultiSelectionTaskClear();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: todoController.isMultiSelectionTask.isTrue
                  ? IconButton(
                      onPressed: () =>
                          todoController.doMultiSelectionTaskClear(),
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
                  visible: todoController.selectedTask.isNotEmpty,
                  child: IconButton(
                    icon: const Icon(
                      Iconsax.trush_square,
                      size: 20,
                    ),
                    onPressed: () async {
                      await showAdaptiveDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog.adaptive(
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
                                          ?.copyWith(
                                              color: Colors.blueAccent))),
                              TextButton(
                                  onPressed: () {
                                    todoController.deleteTask(
                                        todoController.selectedTask);
                                    todoController.doMultiSelectionTaskClear();
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
                  visible: todoController.selectedTask.isNotEmpty,
                  child: IconButton(
                    icon: Icon(
                      tabController.index == 0
                          ? Iconsax.archive_1
                          : Iconsax.refresh_left_square,
                      size: 20,
                    ),
                    onPressed: () async {
                      await showAdaptiveDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog.adaptive(
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
                                          ?.copyWith(
                                              color: Colors.blueAccent))),
                              TextButton(
                                  onPressed: () {
                                    tabController.index == 0
                                        ? todoController.archiveTask(
                                            todoController.selectedTask)
                                        : todoController.noArchiveTask(
                                            todoController.selectedTask);
                                    todoController.doMultiSelectionTaskClear();
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
                                horizontal: 10, vertical: 5),
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
                          Statistics(
                            createdTodos: createdTodos,
                            completedTodos: completedTodos,
                            precent: precent,
                          ),
                        ],
                      ),
                    ),
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context),
                      sliver: SliverPersistentHeader(
                        delegate: MyDelegate(
                          TabBar(
                            tabAlignment: TabAlignment.start,
                            controller: tabController,
                            isScrollable: true,
                            dividerColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>(
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
                    TasksList(
                      archived: false,
                      searhTask: filter,
                    ),
                    TasksList(
                      archived: true,
                      searhTask: filter,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
