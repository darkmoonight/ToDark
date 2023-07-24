import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate(this.tabBar);
  final TabBar tabBar;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: context.theme.primaryColor,
      height: 40,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
