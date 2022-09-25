import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' as mobx;
import 'package:mocktail/mocktail.dart';
import 'package:prodea/core/helpers/navigation.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/domain/usecases/auth/get_current_user.dart';
import 'package:prodea/src/presentation/controllers/main_page_controller.dart';

import '../../../test_helpers/mobx.dart';

class MockModularNavigator extends Mock implements IModularNavigator {}

class MockGetCurrentUser extends Mock implements GetCurrentUser {}

void main() {
  late IModularNavigator modularNavigatorMock;
  late GetCurrentUser getCurrentUserMock;
  late MainPageController controller;

  const tDonorUser = User(
    id: 'id',
    email: 'email',
    cnpj: 'cnpj',
    name: 'name',
    address: 'address',
    city: 'city',
    phoneNumber: 'phoneNumber',
    about: 'about',
    responsibleName: 'responsibleName',
    responsibleCpf: 'responsibleCpf',
    isDonor: true,
    isBeneficiary: false,
    isAdmin: false,
    status: AuthorizationStatus.authorized,
  );
  const tBeneficiaryUser = User(
    id: 'id',
    email: 'email',
    cnpj: 'cnpj',
    name: 'name',
    address: 'address',
    city: 'city',
    phoneNumber: 'phoneNumber',
    about: 'about',
    responsibleName: 'responsibleName',
    responsibleCpf: 'responsibleCpf',
    isDonor: false,
    isBeneficiary: true,
    isAdmin: false,
    status: AuthorizationStatus.authorized,
  );
  const tBothUser = User(
    id: 'id',
    email: 'email',
    cnpj: 'cnpj',
    name: 'name',
    address: 'address',
    city: 'city',
    phoneNumber: 'phoneNumber',
    about: 'about',
    responsibleName: 'responsibleName',
    responsibleCpf: 'responsibleCpf',
    isDonor: true,
    isBeneficiary: true,
    isAdmin: false,
    status: AuthorizationStatus.authorized,
  );
  final tPageInfo = PageInfo(
    route: '/test',
    icon: Icons.abc,
    title: 'Teste',
    abbrTitle: 'Teste',
  );

  setUp(() {
    modularNavigatorMock = MockModularNavigator();
    getCurrentUserMock = MockGetCurrentUser();

    when(getCurrentUserMock).thenAnswer((_) => const Stream<User?>.empty());

    controller = MainPageController(getCurrentUserMock);

    Modular.navigatorDelegate = modularNavigatorMock;
  });

  group('init', () {
    test(
      'deve inicializar o controller, populando a lista de pageInfos com as '
      'páginas de doador, quando o usuário é um doador.',
      () async {
        // arrange
        when(getCurrentUserMock)
            .thenAnswer((_) => Stream.fromIterable([tDonorUser]));
        final pageInfosChanged = MockCallable<List<PageInfo>>();
        whenReaction((_) => controller.pageInfos, pageInfosChanged);
        // act
        controller.init();
        await untilCalled(() => pageInfosChanged(any()));
        await untilCalled(() => pageInfosChanged(any()));
        await Future.delayed(const Duration(seconds: 1));
        // assert
        expect(controller.pageInfos.length, 2);
        expect(controller.pageInfos[0].title, 'Doar');
        expect(controller.pageInfos[1].title, 'Minhas Doações');
      },
    );

    test(
      'deve inicializar o controller, populando a lista de pageInfos com as '
      'páginas de beneficiário, quando o usuário é um beneficiário.',
      () async {
        // arrange
        when(getCurrentUserMock)
            .thenAnswer((_) => Stream.fromIterable([tBeneficiaryUser]));
        final pageInfosChanged = MockCallable<List<PageInfo>>();
        whenReaction((_) => controller.pageInfos, pageInfosChanged);
        // act
        controller.init();
        await untilCalled(() => pageInfosChanged(any()));
        await untilCalled(() => pageInfosChanged(any()));
        await Future.delayed(const Duration(seconds: 1));
        // assert
        expect(controller.pageInfos.length, 2);
        expect(controller.pageInfos[0].title, 'Doações Disponíveis');
        expect(controller.pageInfos[1].title, 'Doações Solicitadas');
      },
    );

    test(
      'deve inicializar o controller, populando a lista de pageInfos com todas '
      'as páginas, quando o usuário é um doador e beneficiário.',
      () async {
        // arrange
        when(getCurrentUserMock)
            .thenAnswer((_) => Stream.fromIterable([tBothUser]));
        final pageInfosChanged = MockCallable<List<PageInfo>>();
        whenReaction((_) => controller.pageInfos, pageInfosChanged);
        // act
        controller.init();
        await untilCalled(() => pageInfosChanged(any()));
        await untilCalled(() => pageInfosChanged(any()));
        await untilCalled(() => pageInfosChanged(any()));
        await untilCalled(() => pageInfosChanged(any()));
        await Future.delayed(const Duration(seconds: 1));
        // assert
        expect(controller.pageInfos.length, 4);
        expect(controller.pageInfos[0].title, 'Doar');
        expect(controller.pageInfos[1].title, 'Minhas Doações');
        expect(controller.pageInfos[2].title, 'Doações Disponíveis');
        expect(controller.pageInfos[3].title, 'Doações Solicitadas');
      },
    );

    test(
      'deve inicializar o controller, e ouvir a troca de páginas, alterando o '
      'index da página atual.',
      () async {
        // arrange
        when(getCurrentUserMock)
            .thenAnswer((_) => Stream.fromIterable([tDonorUser]));
        final pageInfosChanged = MockCallable<List<PageInfo>>();
        whenReaction((_) => controller.pageInfos, pageInfosChanged);
        final currentPageIndexChanged = MockCallable<int>();
        whenReaction(
            (_) => controller.currentPageIndex, currentPageIndexChanged);
        // act
        controller.init();
        await untilCalled(() => pageInfosChanged(any()));
        await untilCalled(() => pageInfosChanged(any()));
        await Future.delayed(const Duration(seconds: 1));
        NavigationHelper.goTo('/main/my-donations', replace: true);
        await untilCalled(() => currentPageIndexChanged(any()));
        // assert
        expect(controller.currentPageIndex, 1);
      },
    );
  });

  group('currentPageInfo', () {
    test(
      'deve retornar uma pageInfo quando o índex atual for 0 ou maior, e a '
      'array de pageInfos não estiver vazia.',
      () {
        // act
        controller.pageInfos = mobx.ObservableList.of([tPageInfo]);
        controller.currentPageIndex = 0;
        final result = controller.currentPageInfo;
        // assert
        expect(result, tPageInfo);
      },
    );

    test(
      'deve retornar null quando o índex atual for 0 ou maior, e a array de '
      'pageInfos estiver vazia.',
      () {
        // act
        controller.pageInfos = mobx.ObservableList.of([]);
        controller.currentPageIndex = 0;
        final result = controller.currentPageInfo;
        // assert
        expect(result, null);
      },
    );

    test(
      'deve retornar a primeira pageInfo quando o índex atual for menor que 0, '
      'e a array de pageInfos não estiver vazia.',
      () {
        // act
        controller.pageInfos = mobx.ObservableList.of([tPageInfo]);
        controller.currentPageIndex = -1;
        final result = controller.currentPageInfo;
        // assert
        expect(result, controller.pageInfos[0]);
      },
    );
  });

  group('navigateToPage', () {
    test(
      'deve navegar para rota da página correspondente ao index informado.',
      () async {
        // arrange
        when(getCurrentUserMock).thenAnswer((_) => Stream.fromIterable([null]));
        final pageInfosChanged = MockCallable<List<PageInfo>>();
        whenReaction((_) => controller.pageInfos, pageInfosChanged);
        final currentPageIndexChanged = MockCallable<int>();
        whenReaction(
            (_) => controller.currentPageIndex, currentPageIndexChanged);
        // act
        controller.init();
        await untilCalled(() => pageInfosChanged(any()));
        controller.pageInfos = mobx.ObservableList.of([tPageInfo]);
        controller.currentPageIndex = -1;
        controller.navigateToPage(0);
        await untilCalled(() => currentPageIndexChanged(any()));
        final result = controller.currentPageInfo;
        // assert
        expect(result, tPageInfo);
      },
    );
  });

  group('toString', () {
    test(
      'deve retornar uma string.',
      () {
        // act
        final result = controller.toString();
        // assert
        expect(result, isA<String>());
      },
    );
  });
}
