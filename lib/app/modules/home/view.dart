import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dark_todo/app/core/values/colors.dart';
import 'package:dark_todo/app/data/models/task.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:dark_todo/app/modules/home/widgets/add_card.dart';
import 'package:dark_todo/app/modules/home/widgets/add_dialog.dart';
import 'package:dark_todo/app/modules/home/widgets/task_card.dart';
import 'package:dark_todo/app/modules/report/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      body: Obx(
        () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            SafeArea(
              child: ListView(
                controller: ScrollController(),
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.w, left: 4.w, bottom: 2.w),
                    child: Text(
                      DateFormat.yMMMMEEEEd().format(
                        DateTime.now(),
                      ),
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Hey, Yoshi!',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Obx(
                    () => GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        ...controller.tasks
                            .map((element) => LongPressDraggable(
                                data: element,
                                onDragStarted: () =>
                                    controller.changeDeleting(true),
                                onDraggableCanceled: (_, __) =>
                                    controller.changeDeleting(false),
                                onDragEnd: (_) =>
                                    controller.changeDeleting(false),
                                feedback: Opacity(
                                  opacity: 0.8,
                                  child: TaskCard(task: element),
                                ),
                                child: TaskCard(task: element)))
                            .toList(),
                        AddCard()
                      ],
                    ),
                  )
                ],
              ),
            ),
            ReportPage(),
          ],
        ),
      ),
      floatingActionButton: DragTarget<Task>(
        builder: (_, __, ___) {
          return Obx(
            () => FloatingActionButton(
              backgroundColor: controller.deleting.value ? Colors.red : blue,
              onPressed: () {
                if (controller.tasks.isNotEmpty) {
                  Get.to(() => AddDialog(), transition: Transition.downToUp);
                } else {
                  EasyLoading.showInfo('Please create your task type');
                }
              },
              child: Icon(
                controller.deleting.value ? Icons.delete : Icons.add,
              ),
            ),
          );
        },
        onAccept: (Task task) {
          controller.deleteTask(task);
          EasyLoading.showSuccess('Delete Sucess');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Obx(
          () => BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 25, 25, 25),
            onTap: (int index) => controller.changeTabIndex(index),
            currentIndex: controller.tabIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Padding(
                  padding: EdgeInsets.only(
                    right: 15.w,
                  ),
                  child: const Icon(
                    Icons.apps,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                label: 'Report',
                icon: Padding(
                  padding: EdgeInsets.only(
                    left: 15.w,
                  ),
                  child: const Icon(
                    Icons.data_usage,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
