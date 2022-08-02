import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dark_todo/app/core/values/colors.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class ReportPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      body: SafeArea(child: Obx(
        () {
          var createdTasks = homeCtrl.getTotalTask();
          var completedTasks = homeCtrl.getTotalDoneTask();
          var liveTasks = createdTasks - completedTasks;
          var precent =
              (completedTasks / createdTasks * 100).toStringAsFixed(0);
          return ListView(
            controller: ScrollController(),
            children: [
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  'My Report',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                ),
                child: Text(
                  DateFormat.yMMMMd().format(
                    DateTime.now(),
                  ),
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 3.w,
                  horizontal: 4.w,
                ),
                child: const Divider(
                  thickness: 2,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 3.w,
                  horizontal: 5.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatus(Colors.green, liveTasks, 'Live Tasks'),
                    _buildStatus(Colors.orange, completedTasks, 'Completed'),
                    _buildStatus(Colors.blue, createdTasks, 'Creared'),
                  ],
                ),
              ),
              SizedBox(
                height: 8.w,
              ),
              UnconstrainedBox(
                child: SizedBox(
                  width: 70.w,
                  height: 70.w,
                  child: CircularStepProgressIndicator(
                    totalSteps: createdTasks == 0 ? 1 : createdTasks,
                    currentStep: completedTasks,
                    stepSize: 20,
                    selectedColor: green,
                    unselectedColor: Colors.grey[200],
                    padding: 0,
                    width: 150,
                    height: 150,
                    selectedStepSize: 22,
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
                          height: 1.w,
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
          );
        },
      )),
    );
  }

  Row _buildStatus(Color color, int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 3.w,
          width: 3.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 0.5.w,
              color: color,
            ),
          ),
        ),
        SizedBox(
          width: 3.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 2.w,
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ],
    );
  }
}
