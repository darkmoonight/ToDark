import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dark_todo/app/data/models/task.dart';
import 'package:dark_todo/app/modules/detail/view.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  final Task task;
  TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final color = HexColor.fromHex(task.color);
    final squareWidth = Get.width - 40.w;

    return GestureDetector(
      onTap: () {
        homeCtrl.changeTask(task);
        homeCtrl.changeTodos(task.todos ?? []);
        Get.to(() => const DetailPage(), transition: Transition.downToUp);
      },
      child: Container(
        padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 15.w),
        width: squareWidth / 2,
        height: squareWidth / 2,
        margin: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          color: theme.primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              IconData(task.icon, fontFamily: 'MaterialIcons'),
              color: color,
              size: 20.sp,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: 30.w,
              ),
            ),
            Text(
              task.title,
              style: theme.textTheme.headline4,
              overflow: TextOverflow.ellipsis,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: 26.w,
              ),
            ),
            Text(
              '${task.todos?.length ?? 0} ${AppLocalizations.of(context)!.task(task.todos?.length ?? 0)}',
              style: theme.textTheme.subtitle2,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: SizedBox(
                height: 9.w,
              ),
            ),
            StepProgressIndicator(
              totalSteps: homeCtrl.isTodosEmpty(task) ? 1 : task.todos!.length,
              currentStep:
                  homeCtrl.isTodosEmpty(task) ? 0 : homeCtrl.getDoneTodo(task),
              size: 4.w,
              padding: 0,
              roundedEdges: const Radius.circular(10),
              selectedGradientColor: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.5), color],
              ),
              unselectedColor: theme.unselectedWidgetColor,
            ),
          ],
        ),
      ),
    );
  }
}
