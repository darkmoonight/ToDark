import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectButton extends StatefulWidget {
  final List<Icon> icons;
  final ValueChanged onToggleCallback;
  final Color backgroundColor;
  final Color buttonColor;

  const SelectButton({
    super.key,
    required this.icons,
    required this.onToggleCallback,
    this.backgroundColor = Colors.black,
    this.buttonColor = Colors.white,
  });
  @override
  State<SelectButton> createState() => _SelectButtonState();
}

class _SelectButtonState extends State<SelectButton> {
  bool initialPosition = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.2,
      height: Get.width * 0.1,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              initialPosition = !initialPosition;
              var index = 0;
              if (!initialPosition) {
                index = 1;
              }
              widget.onToggleCallback(index);
            },
            child: Container(
              width: Get.width * 0.2,
              height: Get.width * 0.1,
              decoration: ShapeDecoration(
                color: widget.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  widget.icons.length,
                  (index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                    child: widget.icons[index],
                  ),
                ),
              ),
            ),
          ),
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.decelerate,
            alignment:
                initialPosition ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: Get.width * 0.1,
              height: Get.width * 0.08,
              decoration: ShapeDecoration(
                color: widget.buttonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              alignment: Alignment.center,
              child: initialPosition ? widget.icons[0] : widget.icons[1],
            ),
          ),
        ],
      ),
    );
  }
}
