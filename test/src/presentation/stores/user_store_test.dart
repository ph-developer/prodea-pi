import 'package:flutter_test/flutter_test.dart';
import 'package:prodea/src/domain/entities/user.dart';
import 'package:prodea/src/presentation/stores/user_store.dart';

void main() {
  late UserStore store;

  setUp(() {
    store = UserStore();
  });

  test(
    'deve retornar um usuário com os atributos provenientes das variaveis.',
    () {
      // arrange
      store.email = 'email';
      store.cnpj = 'cnpj';
      store.name = 'name';
      store.address = 'address';
      store.city = 'city';
      store.phoneNumber = 'phoneNumber';
      store.about = 'about';
      store.responsibleName = 'responsibleName';
      store.responsibleCpf = 'responsibleCpf';
      store.isDonor = true;
      store.isBeneficiary = true;
      // act
      final result = store.user;
      // assert
      expect(result, isA<User>());
      expect(result.email, store.email);
      expect(result.cnpj, store.cnpj);
      expect(result.name, store.name);
      expect(result.address, store.address);
      expect(result.city, store.city);
      expect(result.phoneNumber, store.phoneNumber);
      expect(result.about, store.about);
      expect(result.responsibleName, store.responsibleName);
      expect(result.responsibleCpf, store.responsibleCpf);
      expect(result.isDonor, store.isDonor);
      expect(result.isBeneficiary, store.isBeneficiary);
    },
  );

  test(
    'deve retornar uma string.',
    () {
      // act
      final result = store.toString();
      // assert
      expect(result, isA<String>());
    },
  );
}
