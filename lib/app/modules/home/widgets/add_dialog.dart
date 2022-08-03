import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddDialog extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                        homeCtrl.editCtrl.clear();
                        homeCtrl.changeTask(null);
                      },
                      icon: const Icon(Icons.close),
                      color: Colors.white,
                      iconSize: 20.sp,
                    ),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () {
                          if (homeCtrl.formKey.currentState!.validate()) {
                            if (homeCtrl.task.value == null) {
                              EasyLoading.showError('Please select task type');
                            } else {
                              var success = homeCtrl.updateTask(
                                homeCtrl.task.value!,
                                homeCtrl.editCtrl.text,
                              );
                              if (success) {
                                EasyLoading.showSuccess(
                                    'Todo item add success');
                                Get.back();
                                homeCtrl.changeTask(null);
                              } else {
                                EasyLoading.showError(
                                    'Todo item already exist');
                              }
                              homeCtrl.editCtrl.clear();
                            }
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Text(
                  'Create New Task',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
                child: TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                  controller: homeCtrl.editCtrl,
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
                      fontSize: 15.sp,
                    ),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your todo item';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 15.w,
                  right: 15.w,
                  bottom: 5.w,
                ),
                child: Text(
                  'Add to ',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              ...homeCtrl.tasks
                  .map((element) => Obx(() => InkWell(
                      onTap: () => homeCtrl.changeTask(element),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10.w,
                            horizontal: 15.w,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    IconData(
                                      element.icon,
                                      fontFamily: 'MaterialIcons',
                                    ),
                                    color: HexColor.fromHex(element.color),
                                    size: 20.sp,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Text(
                                    element.title,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                              if (homeCtrl.task.value == element)
                                const Icon(
                                  Icons.check,
                                  color: Colors.blue,
                                )
                            ],
                          )))))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
