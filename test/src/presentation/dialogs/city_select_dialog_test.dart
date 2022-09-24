import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:prodea/src/presentation/dialogs/city_select_dialog.dart';
import 'package:prodea/src/presentation/stores/cities_store.dart';

import '../../../test_helpers/finder.dart';
import '../../../test_helpers/mobx.dart';

class MockCitiesStore extends Mock implements CitiesStore {}

class TestModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.instance<CitiesStore>(MockCitiesStore()),
      ];
}

void main() {
  const tScaffoldKey = Key('scaffold');
  late CitiesStore citiesStoreMock;

  setUp(() {
    citiesStoreMock = MockCitiesStore();

    when(() => citiesStoreMock.cities)
        .thenReturn(mobx.ObservableList.of(['Araçatuba/SP', 'Penápolis/SP']));

    initModule(TestModule(), replaceBinds: [
      Bind.instance<CitiesStore>(citiesStoreMock),
    ]);
  });

  Widget createWidgetUnderTest() {
    return ModularApp(
      module: TestModule(),
      child: MaterialApp(
        builder: Asuka.builder,
        home: const Scaffold(
          key: tScaffoldKey,
        ),
      ),
    );
  }

  testWidgets(
    'deve mostrar um diálogo, interagir com ele e retornar uma string na função onOk.',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final onSelect = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));
      showCitySelectDialog(context, onSelect: onSelect);

      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(2));
      expect(find.byType(IconButton), findsNothing);
      expect(find.text('Araçatuba/SP'), findsOneWidget);
      expect(find.text('Penápolis/SP'), findsOneWidget);

      final textFormField = findWidgetByType<TextFormField>(TextFormField);

      await tester.enterText(find.byWidget(textFormField), 'enapo');
      await tester.pump();

      expect(find.byType(IconButton), findsOneWidget);
      expect(find.text('Araçatuba/SP'), findsNothing);
      expect(find.text('Penápolis/SP'), findsOneWidget);

      final clearFilterButton = findWidgetByType<IconButton>(IconButton);

      await tester.tap(find.byWidget(clearFilterButton));
      await tester.pump();

      expect(find.byType(IconButton), findsNothing);
      expect(find.text('Araçatuba/SP'), findsOneWidget);
      expect(find.text('Penápolis/SP'), findsOneWidget);

      final penapolisText = findWidgetByText<Text>('Penápolis/SP');
      final penapolisListTile = find
          .ancestor(
            of: find.byWidget(penapolisText),
            matching: find.byType(ListTile),
          )
          .evaluate()
          .first
          .widget as ListTile;

      await tester.tap(find.byWidget(penapolisListTile));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
      verify(() => onSelect('Penápolis/SP')).called(1);
    },
  );

  testWidgets(
    'deve mostrar um diálogo e fechar ao clicar no botão de voltar.',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final onSelect = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));
      showCitySelectDialog(context, onSelect: onSelect);

      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);

      final backButton = findWidgetByType<TextButton>(TextButton);

      expect(backButton.enabled, true);

      await tester.tap(find.byWidget(backButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(() => onSelect(any()));
    },
  );

  testWidgets(
    'deve mostrar um diálogo e retornar uma string vazia ao clicar no botão de limpar.',
    (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final onSelect = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));
      showCitySelectDialog(context, onSelect: onSelect);

      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);

      final clearButton = findWidgetByType<TextButton>(TextButton, 1);

      expect(clearButton.enabled, true);

      await tester.tap(find.byWidget(clearButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsNothing);
      verify(() => onSelect('')).called(1);
    },
  );
}
