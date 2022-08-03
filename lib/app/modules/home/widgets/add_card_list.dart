import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/data/models/task.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:dark_todo/app/widgets/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddCardList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCardList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
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
                        homeCtrl.changeChipIndex(0);
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
                              int icon = icons[homeCtrl.chipIndex.value]
                                  .icon!
                                  .codePoint;
                              String color = icons[homeCtrl.chipIndex.value]
                                  .color!
                                  .toHex();
                              var task = Task(
                                title: homeCtrl.editCtrl.text,
                                icon: icon,
                                color: color,
                              );
                              Get.back();
                              homeCtrl.editCtrl.clear();
                              homeCtrl.addTask(task)
                                  ? EasyLoading.showSuccess('Create sucess')
                                  : EasyLoading.showError('Duplicated Task');
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
                  'Task Type',
                  style: TextStyle(
                    fontSize: 20.sp,
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
                    hintText: "Task Type",
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15.sp,
                    ),
                  ),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your task type';
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
                  'Icons',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 15.w),
                child: Wrap(
                  spacing: 8.w,
                  children: icons
                      .map((e) => Obx(() {
                            final index = icons.indexOf(e);
                            return ChoiceChip(
                              selectedColor: Colors.grey[200],
                              pressElevation: 0,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.padded,
                              backgroundColor:
                                  const Color.fromARGB(255, 40, 40, 40),
                              label: e,
                              selected: homeCtrl.chipIndex.value == index,
                              onSelected: (bool selected) {
                                homeCtrl.chipIndex.value = selected ? index : 0;
                              },
                            );
                          }))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
