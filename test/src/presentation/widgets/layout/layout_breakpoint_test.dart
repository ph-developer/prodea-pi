import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/presentation/widgets/layout/breakpoint.dart';
import 'package:prodea/src/presentation/widgets/layout/layout_breakpoint.dart';

import '../../../../mocks/widgets.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  const tWidget = LayoutBreakpoint(
    xs: Text('xs'),
    sm: Text('sm'),
    md: Text('md'),
    lg: Text('lg'),
    xl: Text('xl'),
    xxl: Text('xxl'),
  );
  const tMdOnlyWidget = LayoutBreakpoint(
    md: Text('md'),
  );

  group('xs', () {
    testWidgets('deve mostrar apenas o widget xs (largura mínima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.xs.minDimension * 1,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsOneWidget);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('deve mostrar apenas o widget xs (largura máxima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.sm.minDimension - 0.001,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsOneWidget);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('sm', () {
    testWidgets('deve mostrar apenas o widget sm (largura mínima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.sm.minDimension * 1,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsOneWidget);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('deve mostrar apenas o widget sm (largura máxima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.md.minDimension - 0.001,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsOneWidget);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('md', () {
    testWidgets('deve mostrar apenas o widget md (largura mínima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.md.minDimension * 1,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsOneWidget);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('deve mostrar apenas o widget md (largura máxima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.lg.minDimension - 0.001,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsOneWidget);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('lg', () {
    testWidgets('deve mostrar apenas o widget lg (largura mínima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.lg.minDimension * 1,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsOneWidget);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('deve mostrar apenas o widget lg (largura máxima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.xl.minDimension - 0.001,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsOneWidget);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('xl', () {
    testWidgets('deve mostrar apenas o widget xl (largura mínima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.xl.minDimension * 1,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsOneWidget);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('deve mostrar apenas o widget xl (largura máxima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.xxl.minDimension - 0.001,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsOneWidget);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('xxl', () {
    testWidgets('deve mostrar apenas o widget xxl (largura mínima)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.xxl.minDimension * 1,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(tWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsOneWidget);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });
  });

  group('empty', () {
    testWidgets('não deve mostrar nenhum widget (widgets em branco)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = Size(
        Breakpoint.xxl.minDimension * 1,
        100,
      );
      binding.window.devicePixelRatioTestValue = 1.0;
      await tester.pumpWidget(makeWidgetTestable(const LayoutBreakpoint()));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });

    testWidgets('não deve mostrar nenhum widget (tamanho não encontrado)',
        (tester) async {
      // arrange
      binding.window.physicalSizeTestValue = const Size(0, 10);
      await tester.pumpWidget(makeWidgetTestable(tMdOnlyWidget));

      // assert
      expect(find.text('xs'), findsNothing);
      expect(find.text('sm'), findsNothing);
      expect(find.text('md'), findsNothing);
      expect(find.text('lg'), findsNothing);
      expect(find.text('xl'), findsNothing);
      expect(find.text('xxl'), findsNothing);

      // tearDown
      addTearDown(binding.window.clearPhysicalSizeTestValue);
    });
  });
}
