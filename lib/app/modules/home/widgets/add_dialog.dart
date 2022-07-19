import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class AddDialog extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: homeCtrl.formKey,
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(3.0.wp),
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
                              EasyLoading.showSuccess('Todo item add success');
                              Get.back();
                              homeCtrl.changeTask(null);
                            } else {
                              EasyLoading.showError('Todo item already exist');
                            }
                            homeCtrl.editCtrl.clear();
                          }
                        }
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 14.4.sp,
                        ),
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
              child: Text(
                'New Task',
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
              child: TextFormField(
                controller: homeCtrl.editCtrl,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400]!),
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
                top: 5.0.wp,
                left: 5.0.wp,
                right: 5.0.wp,
                bottom: 2.0.wp,
              ),
              child: Text(
                'Add to ',
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.grey,
                ),
              ),
            ),
            ...homeCtrl.tasks
                .map((element) => Obx(() => InkWell(
                    onTap: () => homeCtrl.changeTask(element),
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 3.0.wp,
                          horizontal: 5.0.wp,
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
                                ),
                                SizedBox(
                                  width: 3.0.wp,
                                ),
                                Text(
                                  element.title,
                                  style: TextStyle(
                                    fontSize: 12.0.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
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
    );
  }
}
