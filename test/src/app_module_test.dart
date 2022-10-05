import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:modular_test/modular_test.dart';
import 'package:prodea/src/app_module.dart';

import '../mocks/mocks.dart';

void main() {
  late AppModule module;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    module = AppModule();
  });

  test(
    'deve inicializar o módulo app com sucesso.',
    () {
      // act
      initModule(module);
      // expect
      expect(module.routes, isA<List<ModularRoute>>());
      for (var route in module.routes) {
        if (route is ChildRoute) {
          final page = route.child!(MockBuildContext(), MockModularArguments());
          expect(page, isA<Widget>());
        }
      }
    },
  );
}
