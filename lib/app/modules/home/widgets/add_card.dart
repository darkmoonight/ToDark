import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:dark_todo/app/modules/home/widgets/add_card_list.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var squareWidth = Get.width - 12.w;
    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(15.w),
      child: InkWell(
        onTap: () {
          Get.to(() => AddCardList(), transition: Transition.downToUp);
        },
        child: DottedBorder(
          color: theme.unselectedWidgetColor,
          dashPattern: const [8, 4],
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          child: Center(
            child: Icon(
              Icons.add,
              size: theme.iconTheme.size,
              color: theme.unselectedWidgetColor,
            ),
          ),
        ),
      ),
    );
  }
}
