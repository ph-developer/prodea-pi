import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/presentation/widgets/layout/breakpoint.dart';
import 'package:prodea/src/presentation/widgets/layout/layout_visibility.dart';

import '../../../../mocks/widgets.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();

  group('greater', () {
    group('xs', () {
      const tBreakpoint = Breakpoint.xs;
      final tWidget = LayoutVisibility.greater(
        tBreakpoint,
        const Text('xs'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xs'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('sm', () {
      const tBreakpoint = Breakpoint.sm;
      final tWidget = LayoutVisibility.greater(
        tBreakpoint,
        const Text('sm'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('sm'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('sm'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('md', () {
      const tBreakpoint = Breakpoint.md;
      final tWidget = LayoutVisibility.greater(
        tBreakpoint,
        const Text('md'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('md'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('md'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('lg', () {
      const tBreakpoint = Breakpoint.lg;
      final tWidget = LayoutVisibility.greater(
        tBreakpoint,
        const Text('lg'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('lg'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('lg'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('xl', () {
      const tBreakpoint = Breakpoint.xl;
      final tWidget = LayoutVisibility.greater(
        tBreakpoint,
        const Text('xl'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xl'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xl'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('xxl', () {
      const tBreakpoint = Breakpoint.xxl;
      final tWidget = LayoutVisibility.greater(
        tBreakpoint,
        const Text('xxl'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xxl'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xxl'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });
  });

  group('lesser', () {
    group('xs', () {
      const tBreakpoint = Breakpoint.xs;
      final tWidget = LayoutVisibility.lesser(
        tBreakpoint,
        const Text('xs'),
      );

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xs'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('sm', () {
      const tBreakpoint = Breakpoint.sm;
      final tWidget = LayoutVisibility.lesser(
        tBreakpoint,
        const Text('sm'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('sm'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('sm'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('md', () {
      const tBreakpoint = Breakpoint.md;
      final tWidget = LayoutVisibility.lesser(
        tBreakpoint,
        const Text('md'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('md'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('md'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('lg', () {
      const tBreakpoint = Breakpoint.lg;
      final tWidget = LayoutVisibility.lesser(
        tBreakpoint,
        const Text('lg'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('lg'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('lg'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('xl', () {
      const tBreakpoint = Breakpoint.xl;
      final tWidget = LayoutVisibility.lesser(
        tBreakpoint,
        const Text('xl'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xl'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xl'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });

    group('xxl', () {
      const tBreakpoint = Breakpoint.xxl;
      final tWidget = LayoutVisibility.lesser(
        tBreakpoint,
        const Text('xxl'),
      );

      testWidgets('deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension - 0.001,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xxl'), findsOneWidget);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });

      testWidgets('não deve mostrar o widget', (tester) async {
        // arrange
        binding.window.physicalSizeTestValue = Size(
          tBreakpoint.minDimension * 1,
          100,
        );
        binding.window.devicePixelRatioTestValue = 1.0;
        await tester.pumpWidget(makeWidgetTestable(tWidget));

        // assert
        expect(find.text('xxl'), findsNothing);

        // tearDown
        addTearDown(binding.window.clearPhysicalSizeTestValue);
      });
    });
  });
}
