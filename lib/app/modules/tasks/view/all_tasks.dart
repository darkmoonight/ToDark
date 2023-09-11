import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/controller/controller.dart';
import 'package:todark/app/modules/tasks/widgets/tasks_list.dart';
import 'package:todark/app/widgets/my_delegate.dart';
import 'package:todark/app/modules/tasks/widgets/statistics.dart';
import 'package:todark/app/widgets/text_form.dart';

class AllTasks extends StatefulWidget {
  const AllTasks({super.key});

  @override
  State<AllTasks> createState() => _AllTasksState();
}

class _AllTasksState extends State<AllTasks> {
  final todoController = Get.put(TodoController());
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'categories'.tr,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
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
                      labelText: 'searchTask'.tr,
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
    );
  }
}
