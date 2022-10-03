import 'package:flutter/material.dart';

import 'breakpoint.dart';

class LayoutVisibility extends StatelessWidget {
  final Widget widget;
  final Breakpoint? greaterThan;
  final Breakpoint? lesserThan;

  const LayoutVisibility._({
    required this.widget,
    this.greaterThan,
    this.lesserThan,
  }) : assert(greaterThan != null || lesserThan != null);

  factory LayoutVisibility.greater(Breakpoint greaterThan, Widget widget) {
    return LayoutVisibility._(widget: widget, greaterThan: greaterThan);
  }

  factory LayoutVisibility.lesser(Breakpoint lesserThan, Widget widget) {
    return LayoutVisibility._(widget: widget, lesserThan: lesserThan);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (greaterThan != null && width >= greaterThan!.minDimension) {
      return widget;
    }

    if (lesserThan != null && width < lesserThan!.minDimension) {
      return widget;
    }

    return Container();
  }
}
