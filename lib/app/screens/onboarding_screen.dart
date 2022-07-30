import 'package:dark_todo/app/modules/home/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 1.w),
      height: 2.w,
      width: isActive ? 4.w : 2.w,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.4, 0.7, 0.9],
              colors: [
                Color.fromARGB(255, 40, 40, 40),
                Color.fromARGB(255, 30, 30, 30),
                Color.fromARGB(255, 20, 20, 20),
                Color.fromARGB(255, 10, 10, 10),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const HomePage())),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width,
                  height: size.height / 1.35,
                  child: PageView(
                    physics: const ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(6.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: const AssetImage(
                                  'assets/images/1.png',
                                ),
                                width: size.width,
                                height: size.height / 2.5,
                              ),
                            ),
                            SizedBox(height: 3.w),
                            Text(
                              'Организуйте свои задачи',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CM Sans Serif',
                                fontSize: 22.sp,
                                height: Adaptive.w(1),
                              ),
                            ),
                            SizedBox(height: Adaptive.w(0.2)),
                            Text(
                              'В нашем приложении вы сможете распределить задачи по категориям и постепено их выполнять.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                height: Adaptive.w(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: const AssetImage(
                                  'assets/images/2.png',
                                ),
                                width: size.width,
                                height: size.height / 2.5,
                              ),
                            ),
                            SizedBox(height: 3.w),
                            Text(
                              'Удобный дизайн',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CM Sans Serif',
                                fontSize: 22.sp,
                                height: Adaptive.w(1),
                              ),
                            ),
                            SizedBox(height: Adaptive.w(0.2)),
                            Text(
                              'Вся навигация сделана так, чтобы можно было максимально удобно и быстро взаимодействовать с приложением.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                height: Adaptive.w(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: const AssetImage(
                                  'assets/images/3.png',
                                ),
                                width: size.width,
                                height: size.height / 2.5,
                              ),
                            ),
                            SizedBox(height: 3.w),
                            Text(
                              'Пользуйтесь с удовольствием',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CM Sans Serif',
                                fontSize: 22.sp,
                                height: Adaptive.w(1),
                              ),
                            ),
                            SizedBox(height: Adaptive.w(0.2)),
                            Text(
                              'Если вы столкнулись с какими-либо проблемами пишите нам на почту или в отзывы приложения.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                height: Adaptive.w(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                          alignment: FractionalOffset.bottomRight,
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Next',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 6.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : const Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 18.w,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HomePage())),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0.w),
                    child: Text(
                      'Get started',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : const Text(''),
    );
  }
}
