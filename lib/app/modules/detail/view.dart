import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/modules/detail/widgets/doing_list.dart';
import 'package:dark_todo/app/modules/detail/widgets/done_list.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class DetailPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.task.value!;
    var color = HexColor.fromHex(task.color);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.updateTodos();
                        homeCtrl.changeTask(null);
                        homeCtrl.editCtrl.clear();
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                child: Row(
                  children: [
                    Icon(
                      IconData(task.icon, fontFamily: 'MaterialIcons'),
                      color: color,
                    ),
                    SizedBox(
                      width: 13.w,
                    ),
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              Obx(() {
                var totalTodos =
                    homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                return Padding(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    top: 14.w,
                    right: 16.w,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$totalTodos Task',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(
                        width: 13.w,
                      ),
                      Expanded(
                        child: StepProgressIndicator(
                          totalSteps: totalTodos == 0 ? 1 : totalTodos,
                          currentStep: homeCtrl.doneTodos.length,
                          size: 5,
                          padding: 0,
                          roundedEdges: const Radius.circular(10),
                          selectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [color.withOpacity(0.5), color],
                          ),
                          unselectedGradientColor: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.grey[300]!, Colors.grey[300]!],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 15.w),
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: homeCtrl.editCtrl,
                  autofocus: true,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 40, 40, 40),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 40, 40, 40),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(255, 40, 40, 40),
                      ),
                    ),
                    hintText: "Task Name",
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    suffixIcon: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        if (homeCtrl.formKey.currentState!.validate()) {
                          var success =
                              homeCtrl.addTodo(homeCtrl.editCtrl.text);
                          if (success) {
                            EasyLoading.showSuccess('Todo item add success');
                          } else {
                            EasyLoading.showError('Todo item already exist');
                          }
                          homeCtrl.editCtrl.clear();
                        }
                      },
                      icon: const Icon(
                        Icons.done,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your todo item';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w),
                child: const Divider(
                  color: Colors.white,
                ),
              ),
              DoingList(),
              DoneList(),
            ],
          ),
        ),
      ),
    );
  }
}
