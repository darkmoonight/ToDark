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
                      controller: TextEditingController(),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
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
          body: const TabBarView(
            children: [
              TasksList(archived: false),
              TasksList(archived: true),
            ],
          ),
        ),
      ),
    );
  }
}
