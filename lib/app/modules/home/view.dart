import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:dark_todo/app/core/values/colors.dart';
import 'package:dark_todo/app/data/models/task.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:dark_todo/app/modules/home/widgets/add_card.dart';
import 'package:dark_todo/app/modules/home/widgets/add_dialog.dart';
import 'package:dark_todo/app/modules/home/widgets/task_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ThemeSwitchingArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color.fromARGB(255, 30, 30, 30),
          body: Obx(
            () {
              var createdTasks = controller.getTotalTask();
              var completedTasks = controller.getTotalDoneTask();
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
                          padding: EdgeInsets.only(
                              top: 15.w, left: 16.w, bottom: 5.w, right: 15.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat.yMMMMEEEEd().format(
                                  DateTime.now(),
                                ),
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              ThemeSwitcher(
                                builder: (context) => IconButton(
                                  onPressed: () {
                                    ThemeSwitcher.of(context).changeTheme(
                                      theme: ThemeModelInheritedNotifier.of(
                                                      context)
                                                  .theme
                                                  .brightness ==
                                              Brightness.light
                                          ? ThemeData.dark()
                                          : ThemeData.light(),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.brightness_4_outlined,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          height: 155.w,
                          margin: EdgeInsets.symmetric(horizontal: 15.w),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 40, 40, 40),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!.motiv,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '$completedTasks ${AppLocalizations.of(context)!.ofMotiv} $createdTasks ${AppLocalizations.of(context)!.completed}',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                              UnconstrainedBox(
                                child: SizedBox(
                                  width: 120.w,
                                  height: 120.w,
                                  child: CircularStepProgressIndicator(
                                    totalSteps:
                                        createdTasks == 0 ? 1 : createdTasks,
                                    currentStep: completedTasks,
                                    stepSize: 4.w,
                                    selectedColor: green,
                                    unselectedColor: Colors.grey[200],
                                    padding: 0,
                                    selectedStepSize: 6.w,
                                    roundedCap: (_, __) => true,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${createdTasks == 0 ? 0 : precent} %',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .efficiency,
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
                          height: 10.w,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.w),
                          child: Text(
                            AppLocalizations.of(context)!.tasks,
                            style: TextStyle(
                              fontSize: 20.sp,
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
                              AddCard(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  // const SettingPage(),
                ],
              );
            },
          ),
          floatingActionButton: DragTarget<Task>(
            builder: (_, __, ___) {
              return Obx(
                () => Padding(
                  padding: EdgeInsets.all(25.h),
                  child: FloatingActionButton.extended(
                    label: Text(
                      controller.deleting.value
                          ? AppLocalizations.of(context)!.todoDelete
                          : AppLocalizations.of(context)!.todoCreate,
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                    ),
                    backgroundColor:
                        controller.deleting.value ? Colors.red : blue,
                    onPressed: () {
                      if (controller.tasks.isNotEmpty) {
                        Get.to(() => AddDialog(),
                            transition: Transition.downToUp);
                      } else {
                        EasyLoading.showInfo(
                            AppLocalizations.of(context)!.showCreate);
                      }
                    },
                    icon: Icon(
                      controller.deleting.value ? Icons.delete : Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
            onAccept: (Task task) {
              controller.deleteTask(task);
              EasyLoading.showSuccess(AppLocalizations.of(context)!.delete);
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }
}
