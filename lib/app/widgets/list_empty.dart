import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListEmpty extends StatelessWidget {
  const ListEmpty({
    super.key,
    required this.img,
    required this.text,
  });
  final String img;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Image.asset(
            img,
            scale: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
