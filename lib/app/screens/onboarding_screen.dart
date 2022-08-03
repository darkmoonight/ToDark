import 'package:carousel_slider/carousel_slider.dart';
import 'package:dark_todo/app/modules/home/view.dart';
import 'package:dark_todo/app/screens/dummy.dart';
import 'package:dark_todo/app/screens/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  CarouselController carouselController = CarouselController();

  storeOnboardInfo() async {
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('OnboardingScreen', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    onboardingItem(ItemModel item) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            item.imageUrl,
            scale: 5,
          ),
          SizedBox(
            height: 35.h,
          ),
          Text(
            item.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
          Text(
            item.subtitle,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: currentIndex == 0 ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: currentIndex == 1 ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  color: currentIndex == 2 ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          MaterialButton(
            onPressed: () {
              if (currentIndex != 2) {
                carouselController.nextPage();
              } else {
                storeOnboardInfo();
                Get.to(() => const HomePage(), transition: Transition.upToDown);
              }
            },
            color: Colors.white,
            minWidth: 150.w,
            padding: EdgeInsets.symmetric(vertical: 15.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              currentIndex == 2 ? 'Get Started' : 'Next',
              style: TextStyle(
                fontSize: 18.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
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
                                horizontal: 15.w, vertical: 10.h),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
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
