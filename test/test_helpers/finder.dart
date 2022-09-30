import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

T findWidgetByType<T>(Type type, [int index = 0]) {
  return find.byType(type).evaluate().elementAt(index).widget as T;
}

T findWidgetByText<T>(String text, [int index = 0]) {
  return find.text(text).evaluate().elementAt(index).widget as T;
}

T findWidgetByIcon<T>(IconData icon, [int index = 0]) {
  return find.byIcon(icon).evaluate().elementAt(index).widget as T;
}
