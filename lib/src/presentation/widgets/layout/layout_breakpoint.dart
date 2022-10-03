import 'package:flutter/material.dart';

import 'breakpoint.dart';

class LayoutBreakpoint extends StatelessWidget {
  /// Widget mostrado quando a largura da tela for maior ou igual a 0px.
  final Widget? xs;

  /// Widget mostrado quando a largura da tela for maior ou igual a 576px.
  final Widget? sm;

  /// Widget mostrado quando a largura da tela for maior ou igual a 768px.
  final Widget? md;

  /// Widget mostrado quando a largura da tela for maior ou igual a 992px.
  final Widget? lg;

  /// Widget mostrado quando a largura da tela for maior ou igual a 1200px.
  final Widget? xl;

  /// Widget mostrado quando a largura da tela for maior ou igual a 1400px.
  final Widget? xxl;

  const LayoutBreakpoint({
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    super.key,
  });

  Map<Breakpoint, Widget> get _widgets => {
        if (xs != null) Breakpoint.xs: xs!,
        if (sm != null) Breakpoint.sm: sm!,
        if (md != null) Breakpoint.md: md!,
        if (lg != null) Breakpoint.lg: lg!,
        if (xl != null) Breakpoint.xl: xl!,
        if (xxl != null) Breakpoint.xxl: xxl!,
      };

  @override
  Widget build(BuildContext context) {
    if (_widgets.isEmpty) return Container();

    final width = MediaQuery.of(context).size.width;
    final greaterBreakpoints =
        _widgets.keys.where((breakpoint) => breakpoint.minDimension <= width);

    if (greaterBreakpoints.isEmpty) return Container();

    final breakpoint = greaterBreakpoints.last;
    final widget = _widgets[breakpoint]!;

    return widget;
  }
}
