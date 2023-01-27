import 'package:todark/app/data/schema.dart';
import 'package:todark/app/modules/home.dart';
import 'package:todark/app/widgets/button.dart';
import 'package:todark/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBordingScreen extends StatefulWidget {
  const OnBordingScreen({super.key});

  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onBoardHome() {
    settings.onboard = true;
    isar.writeTxn(() async => isar.settings.put(settings));
    Get.off(() => const HomePage(), transition: Transition.downToUp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: data.length,
                onPageChanged: (index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  image: data[index].image,
                  title: data[index].title,
                  description: data[index].description,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    data.length,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: DotIndicator(isActive: index == pageIndex),
                        )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: MyTextButton(
                buttonName:
                    pageIndex == data.length - 1 ? 'getStart'.tr : 'next'.tr,
                onTap: () {
                  pageIndex == data.length - 1
                      ? onBoardHome()
                      : pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                },
                bgColor: context.theme.colorScheme.primaryContainer,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    this.isActive = false,
  }) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: isActive
            ? context.theme.dividerColor
            : context.theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
    );
  }
}

class Onboard {
  final String image, title, description;

  Onboard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<Onboard> data = [
  Onboard(
      image: 'assets/images/Task.png',
      title: 'titile1'.tr,
      description: 'subtitle1'.tr),
  Onboard(
      image: 'assets/images/ScrumBoard.png',
      title: 'titile2'.tr,
      description: 'subtitle2'.tr),
  Onboard(
      image: 'assets/images/Done.png',
      title: 'titile3'.tr,
      description: 'subtitle3'.tr),
];

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });
  final String image, title, description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                scale: 5,
              ),
              Text(
                title,
                style: context.theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: Get.width * 0.8,
                child: Text(
                  description,
                  style: context.theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
