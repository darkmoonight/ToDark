import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:dark_todo/utils/theme_controller.dart';
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

import '../../../utils/theme.dart';

class HomePage extends GetView<HomeController> {
  HomePage({Key? key}) : super(key: key);
  final themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    var tag = Localizations.maybeLocaleOf(context)?.toLanguageTag();
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: ThemeSwitchingArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme.scaffoldBackgroundColor,
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
                              top: 15.w, left: 17.w, bottom: 5.w, right: 14.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  DateFormat.yMMMMEEEEd(tag).format(
                                    DateTime.now(),
                                  ),
                                  style: theme.textTheme.headline3),
                              ThemeSwitcher(
                                builder: (context) => IconButton(
                                  onPressed: () {
                                    if (Get.isDarkMode) {
                                      ThemeSwitcher.of(context).changeTheme(
                                          theme: TodoTheme.lightTheme);
                                      themeController
                                          .changeThemeMode(ThemeMode.light);
                                      themeController.saveTheme(false);
                                    } else {
                                      ThemeSwitcher.of(context).changeTheme(
                                          theme: TodoTheme.darkTheme);
                                      themeController
                                          .changeThemeMode(ThemeMode.dark);
                                      themeController.saveTheme(true);
                                    }
                                  },
                                  icon: Icon(
                                    Icons.brightness_4_outlined,
                                    size: theme.iconTheme.size,
                                    color: theme.iconTheme.color,
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
                          decoration: BoxDecoration(
                            color: theme.primaryColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(AppLocalizations.of(context)!.motiv,
                                      style: theme.textTheme.headline2),
                                  Text(
                                    '$completedTasks ${AppLocalizations.of(context)!.ofMotiv} $createdTasks ${AppLocalizations.of(context)!.completed}',
                                    style: theme.textTheme.subtitle1,
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
                                    unselectedColor:
                                        theme.unselectedWidgetColor,
                                    padding: 0,
                                    selectedStepSize: 6.w,
                                    roundedCap: (_, __) => true,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            '${createdTasks == 0 ? 0 : precent} %',
                                            style: theme.textTheme.headline2),
                                        SizedBox(
                                          height: 6.h,
                                        ),
                                        Text(
                                            AppLocalizations.of(context)!
                                                .efficiency,
                                            style: theme.textTheme.subtitle1)
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
                          child: Text(AppLocalizations.of(context)!.tasks,
                              style: theme.textTheme.headline2),
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
                        Get.to(() => const AddDialog(),
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
