import 'package:carousel_slider/carousel_slider.dart';
import 'package:dark_todo/app/modules/home/view.dart';
import 'package:dark_todo/app/screens/dummy.dart';
import 'package:dark_todo/app/screens/item_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

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
            height: 6.w,
          ),
          Text(
            item.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 26.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 2.w,
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
            height: 2.w,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 2.w,
                width: 2.w,
                decoration: BoxDecoration(
                  color: currentIndex == 0 ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                height: 2.w,
                width: 2.w,
                decoration: BoxDecoration(
                  color: currentIndex == 1 ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(
                width: 2.w,
              ),
              Container(
                height: 2.w,
                width: 2.w,
                decoration: BoxDecoration(
                  color: currentIndex == 2 ? Colors.blue : Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2.w,
          ),
          MaterialButton(
            onPressed: () {
              if (currentIndex != 2) {
                carouselController.nextPage();
              } else {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => HomePage()));
              }
            },
            color: Colors.white,
            minWidth: 35.w,
            padding: EdgeInsets.symmetric(vertical: Adaptive.w(2.5)),
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
                                horizontal: 2.w, vertical: 4.w),
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
