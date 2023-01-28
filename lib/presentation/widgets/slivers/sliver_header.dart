import 'package:flutter/material.dart';
import 'package:keeper/domain/utils/styles.dart';

class AppSliverHeader extends StatelessWidget {
  final Widget child;

  const AppSliverHeader({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: Delegate(child),
    );
  }
}

class Delegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  Delegate(this.child);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) => Container(
    padding: const EdgeInsets.only(bottom: 8),
    color: backgroundColor(context),
    child: child
  );

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}