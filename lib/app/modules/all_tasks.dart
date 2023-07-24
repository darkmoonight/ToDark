import 'package:iconsax/iconsax.dart';
import 'package:todark/app/services/controller.dart';
import 'package:todark/app/widgets/my_delegate.dart';
import 'package:todark/app/widgets/todos_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllTaskPage extends StatefulWidget {
  const AllTaskPage({super.key});

  @override
  State<AllTaskPage> createState() => _AllTaskPageState();
}

class _AllTaskPageState extends State<AllTaskPage> {
  final todoController = Get.put(TodoController());
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    super.initState();
  }

  getCountTodos() async {
    countTotalTodos = await todoController.getCountTotalTodos();
    countDoneTodos = await todoController.getCountDoneTodos();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: TextField(
                  style: context.textTheme.labelLarge,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Iconsax.search_normal_1,
                      size: 20,
                    ),
                    labelText: 'searchTodo'.tr,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
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
                      Tab(text: 'done'.tr),
                      Tab(text: 'notDone'.tr),
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
            TodosList(
              calendare: false,
              allTask: true,
              done: false,
            ),
            TodosList(
              calendare: false,
              allTask: true,
              done: true,
            ),
          ],
        ),
      ),
    );
  }
}
