import 'package:flutter/cupertino.dart';

class Scrolling extends ScrollBehavior {
  //...Fields
  final BuildContext? context;

  const Scrolling([this.context]);

  //...Getters
  ScrollPhysics get physics {
    return getScrollPhysics(context!);
  }

  //...Methods
  @override
  Widget buildOverscrollIndicator(context, child, details) {
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      clipBehavior: details.clipBehavior ?? Clip.none,
      child: child,
    );
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }
}
