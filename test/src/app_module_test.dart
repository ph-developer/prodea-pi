// ignore_for_file: depend_on_referenced_packages

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:modular_test/modular_test.dart';
import 'package:prodea/src/app_module.dart';
import 'package:modular_interfaces/modular_interfaces.dart';

import '../mocks/mocks.dart';

void main() {
  late AppModule module;
  late Injector injector;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    module = AppModule();
    injector = MockInjector();
  });

  test(
    'deve inicializar o módulo app com sucesso.',
    () {
      // arrange
      when(() => injector.call()).thenAnswer((_) => Modular.get());
      // act
      initModule(module, replaceBinds: [
        Bind.instance<FirebaseAuth>(MockFirebaseAuth()),
        Bind.instance<FirebaseStorage>(MockFirebaseStorage()),
        Bind.instance<FirebaseFirestore>(MockFirebaseFirestore()),
      ]);
      // expect
      expect(module.binds, isA<List<Bind>>());
      for (var bind in module.binds) {
        if (bind.bindType is FirebaseAuth &&
            bind.bindType is FirebaseStorage &&
            bind.bindType is FirebaseFirestore) {
          final instance = bind.factoryFunction(injector);
          expect(instance, isNotNull);
        }
      }
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
