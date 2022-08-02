import 'package:carousel_slider/carousel_slider.dart';
import 'package:dark_todo/app/modules/home/view.dart';
import 'package:dark_todo/app/screens/dummy.dart';
import 'package:dark_todo/app/screens/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    onboardingItem(ItemModel item) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            item.imageUrl,
            scale: 8,
          ),
          SizedBox(
            height: 40.w,
          ),
          Text(
            item.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20.w,
          ),
          Text(
            item.subtitle,
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 10.w,
                width: 10.w,
                decoration: BoxDecoration(
                  color: currentIndex == 0 ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                height: 10.w,
                width: 10.w,
                decoration: BoxDecoration(
                  color: currentIndex == 1 ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                height: 10.w,
                width: 10.w,
                decoration: BoxDecoration(
                  color: currentIndex == 2 ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.w,
          ),
          MaterialButton(
            onPressed: () {
              if (currentIndex != 2) {
                carouselController.nextPage();
              } else {
                Get.to(() => HomePage(), transition: Transition.upToDown);
              }
            },
            color: Colors.white,
            minWidth: 160.w,
            padding: EdgeInsets.symmetric(vertical: 15.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              currentIndex == 2 ? 'Get Started' : 'Next',
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 40, 40, 40),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Stack(
              children: [
                CarouselSlider(
                  items: data
                      .map((item) => onboardingItem(ItemModel.fromJson(item)))
                      .toList(),
                  options: CarouselOptions(
                    initialPage: currentIndex,
                    height: double.infinity,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                  carouselController: carouselController,
                ),
                currentIndex == 2
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            carouselController.animateToPage(2);
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 10.w),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
