import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
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
import 'package:step_progress_indicator/step_progress_indicator.dart';

class HomePage extends GetView<HomeController> {
  final homeCtrl = Get.find<HomeController>();
  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      body: Obx(
        () {
          var createdTasks = homeCtrl.getTotalTask();
          var completedTasks = homeCtrl.getTotalDoneTask();
          var precent =
              (completedTasks / createdTasks * 100).toStringAsFixed(0);
          return IndexedStack(
            index: controller.tabIndex.value,
            children: [
              SafeArea(
                child: ListView(
                  controller: ScrollController(),
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 14.w, left: 15.w, bottom: 12.w),
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
                    SizedBox(
                      height: 14.w,
                    ),
                    Container(
                      height: 140.w,
                      margin: EdgeInsets.symmetric(horizontal: 14.w),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 40, 40, 40),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                'You tasks plan\nalmost done',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '$completedTasks of $createdTasks completed',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                          UnconstrainedBox(
                            child: SizedBox(
                              width: 135.w,
                              height: 135.w,
                              child: CircularStepProgressIndicator(
                                totalSteps:
                                    createdTasks == 0 ? 1 : createdTasks,
                                currentStep: completedTasks,
                                stepSize: 6,
                                selectedColor: green,
                                unselectedColor: Colors.grey[200],
                                padding: 0,
                                width: 150,
                                height: 150,
                                selectedStepSize: 8,
                                roundedCap: (_, __) => true,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${createdTasks == 0 ? 0 : precent} %',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 11.w,
                                    ),
                                    Text(
                                      'Efficiency',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 13.w,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 12.w),
                      child: Text(
                        'In Progress',
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
          );
        },
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
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                label: 'Home',
                icon: Padding(
                  padding: EdgeInsets.only(
                    right: 115.w,
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
                    left: 115.w,
                  ),
                  child: const Icon(
                    Icons.settings,
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
