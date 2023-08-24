import 'package:iconsax/iconsax.dart';
import 'package:todark/app/services/controller.dart';
import 'package:todark/app/widgets/my_delegate.dart';
import 'package:todark/app/widgets/text_form.dart';
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        physics: const NeverScrollableScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: MyTextForm(
                labelText: 'searchTodo'.tr,
                type: TextInputType.text,
                icon: const Icon(
                  Iconsax.search_normal_1,
                  size: 20,
                ),
                controller: TextEditingController(),
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                      Tab(text: 'doing'.tr),
                      Tab(text: 'done'.tr),
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
