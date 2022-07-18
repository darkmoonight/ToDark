import 'package:dark_todo/app/core/utils/extensions.dart';
import 'package:dark_todo/app/modules/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(0.4.wp),
              child: Text(
                'My List',
                style: TextStyle(
                  fontSize: 7.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
