import 'package:flutter/material.dart';

class If extends StatelessWidget {
  final bool condition;
  final Widget child;
  final Widget? elseChild;

  const If({
    Key? key,
    required this.condition,
    required this.child,
    this.elseChild,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return child;
    }
    if (elseChild != null) {
      return elseChild!;
    }
    return Container();
  }
}
