import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:dark_todo/app/modules/home/widgets/add_card_list.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var squareWidth = Get.width - 12.w;
    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.w),
      child: InkWell(
        onTap: () {
          Get.to(() => AddCardList());
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          child: Center(
            child: Icon(
              Icons.add,
              size: 10.w,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
