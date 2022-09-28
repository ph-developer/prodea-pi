import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final themeData = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: const Color(0xFFFFA250),
  brightness: SchedulerBinding.instance.window.platformBrightness,
);
