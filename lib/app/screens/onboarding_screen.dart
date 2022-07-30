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
        color: isActive ? Colors.white : const Color(0xFF7B51D3),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                Color(0xFF3594DD),
                Color(0xFF4563DB),
                Color(0xFF5036D5),
                Color(0xFF5B16D0),
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
                    onPressed: () => print('Skip'),
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
                  height: 120.w,
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
                                height: 70.w,
                                width: 100.w,
                              ),
                            ),
                            SizedBox(height: 3.w),
                            Text(
                              'Connect people around the world',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CM Sans Serif',
                                fontSize: 22.sp,
                                height: Adaptive.w(1),
                              ),
                            ),
                            SizedBox(height: Adaptive.w(0.2)),
                            Text(
                              'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
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
                                height: 70.w,
                                width: 100.w,
                              ),
                            ),
                            SizedBox(height: 3.w),
                            Text(
                              'Live your life smarter with us!',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CM Sans Serif',
                                fontSize: 22.sp,
                                height: Adaptive.w(1),
                              ),
                            ),
                            SizedBox(height: Adaptive.w(0.2)),
                            Text(
                              'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
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
                                height: 70.w,
                                width: 100.w,
                              ),
                            ),
                            SizedBox(height: 3.w),
                            Text(
                              'Get a new experience of imag',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'CM Sans Serif',
                                fontSize: 22.sp,
                                height: Adaptive.w(1),
                              ),
                            ),
                            SizedBox(height: Adaptive.w(0.2)),
                            Text(
                              'Lorem ipsum dolor sit amet, consect adipiscing elit, sed do eiusmod tempor incididunt ut labore et.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.sp,
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
                        color: const Color(0xFF5B16D0),
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
