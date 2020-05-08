import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SliverCustomPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  SliverCustomPersistentHeaderDelegate({
    @required this.child,
    @required this.minExt,
    @required this.maxExt,
  });

  final Widget child;
  final double minExt, maxExt;

  @override
  double get minExtent => minExt;

  @override
  double get maxExtent => maxExt;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(
      covariant SliverCustomPersistentHeaderDelegate oldDelegate) {
    return child != oldDelegate.child ||
        minExtent != oldDelegate.minExtent ||
        maxExtent != oldDelegate.maxExtent ||
        snapConfiguration != oldDelegate.snapConfiguration ||
        stretchConfiguration != oldDelegate.stretchConfiguration;
  }
}
