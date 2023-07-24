import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:todark/app/services/controller.dart';
import 'package:todark/app/widgets/my_delegate.dart';
import 'package:todark/app/widgets/statistics.dart';
import 'package:todark/app/widgets/task_type_list.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final todoController = Get.put(TodoController());
  int countTotalTodos = 0;
  int countDoneTodos = 0;

  @override
  void initState() {
    getCountTodos();
    super.initState();
  }

  getCountTodos() async {
    final countTotal = await todoController.getCountTotalTodos();
    final countDone = await todoController.getCountDoneTodos();
    setState(() {
      countTotalTodos = countTotal;
      countDoneTodos = countDone;
    });
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
              child: Column(
                children: [
                  Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: TextField(
                      style: context.textTheme.labelLarge,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Iconsax.search_normal_1,
                          size: 20,
                        ),
                        labelText: 'searchTask'.tr,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Statistics(
                    countTotalTodos: countTotalTodos,
                    countDoneTodos: countDoneTodos,
                  ),
                ],
              ),
            ),
            SliverPersistentHeader(
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
                  tabs: const [
                    Tab(text: 'active'),
                    Tab(text: 'archived'),
                  ],
                ),
              ),
              floating: true,
              pinned: true,
            ),
          ];
        },
        body: const TabBarView(
          children: [
            TaskTypeList(archived: false),
            TaskTypeList(archived: true),
          ],
        ),
      ),
    );
  }
}
