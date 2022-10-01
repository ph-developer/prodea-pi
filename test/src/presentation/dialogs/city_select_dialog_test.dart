import 'package:asuka/asuka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:prodea/src/presentation/dialogs/city_select_dialog.dart';
import 'package:prodea/src/presentation/stores/cities_store.dart';

import '../../../mocks/mocks.dart';

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
      // arrange
      Finder widget;
      await tester.pumpWidget(createWidgetUnderTest());
      final onSelect = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));

      // mostrar modal
      showCitySelectDialog(context, onSelect: onSelect);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(TextButton), findsNWidgets(2));
      expect(find.byType(IconButton), findsNothing);
      expect(find.text('Araçatuba/SP'), findsOneWidget);
      expect(find.text('Penápolis/SP'), findsOneWidget);

      // filtrar cidades
      widget = find.byType(TextFormField).at(0);
      await tester.enterText(widget, 'enapo');
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.text('Araçatuba/SP'), findsNothing);
      expect(find.text('Penápolis/SP'), findsOneWidget);

      // limpar o filtro de cidades
      widget = find.byType(IconButton).at(0);
      await tester.tap(widget);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(IconButton), findsNothing);
      expect(find.text('Araçatuba/SP'), findsOneWidget);
      expect(find.text('Penápolis/SP'), findsOneWidget);

      // selecionar cidade
      widget = find.text('Penápolis/SP');
      widget = find.ancestor(of: widget, matching: find.byType(ListTile)).at(0);
      await tester.tap(widget);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsNothing);
      verify(() => onSelect('Penápolis/SP')).called(1);
    },
  );

  testWidgets(
    'deve mostrar um diálogo e fechar ao clicar no botão de voltar.',
    (tester) async {
      // arrange
      Finder widget;
      await tester.pumpWidget(createWidgetUnderTest());
      final onSelect = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));

      // mostrar modal
      showCitySelectDialog(context, onSelect: onSelect);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsOneWidget);

      // voltar
      widget = find.byType(TextButton).at(0);
      await tester.tap(widget);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsNothing);
      verifyNever(() => onSelect(any()));
    },
  );

  testWidgets(
    'deve mostrar um diálogo e retornar uma string vazia ao clicar no botão de limpar.',
    (tester) async {
      // arrange
      Finder widget;
      await tester.pumpWidget(createWidgetUnderTest());
      final onSelect = MockCallable<void>();
      final BuildContext context = tester.element(find.byKey(tScaffoldKey));

      // mostrar modal
      showCitySelectDialog(context, onSelect: onSelect);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsOneWidget);

      // limpar
      widget = find.byType(TextButton).at(1);
      await tester.tap(widget);
      await tester.pumpAndSettle();

      // assert
      expect(find.byType(AlertDialog), findsNothing);
      verify(() => onSelect('')).called(1);
    },
  );
}
