import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

final themeData = kIsWeb ? webThemeData : mobileThemeData;

final webThemeData = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: const Color(0xFFFFA250),
  brightness: Brightness.light,
);

final mobileThemeData = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: const Color(0xFFFFA250),
  brightness: SchedulerBinding.instance.window.platformBrightness,
);
