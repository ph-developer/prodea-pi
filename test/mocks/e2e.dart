import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as firebase show User;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:prodea/src/data/dtos/donation_dto.dart';
import 'package:prodea/src/data/dtos/user_dto.dart';
import 'package:prodea/src/domain/entities/donation.dart';
import 'package:prodea/src/domain/entities/user.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFirebaseUser extends Mock implements firebase.User {}

class MockFirebaseUserCredential extends Mock implements UserCredential {}

class MockFirebaseAuthCredential extends Mock implements AuthCredential {}

FirebaseAuth setupFirebaseAuthMock(bool startLoggedIn) {
  final userMock = MockFirebaseUser();
  final userCredentialMock = MockFirebaseUserCredential();
  final nullCredentialMock = MockFirebaseUserCredential();
  final authMock = MockFirebaseAuth();

  registerFallbackValue(MockFirebaseAuthCredential());

  when(() => userMock.uid).thenReturn("test");
  when(() => userMock.email).thenReturn("test@test.dev");
  when(() => userCredentialMock.user).thenReturn(userMock);
  when(() => nullCredentialMock.user).thenReturn(null);

  UserCredential setCurrentUser(firebase.User? user) {
    when(() => authMock.currentUser).thenAnswer((_) => user);
    when(authMock.authStateChanges)
        .thenAnswer((_) => Stream.fromIterable([user]));
    return user == null ? nullCredentialMock : userCredentialMock;
  }

  setCurrentUser(startLoggedIn ? userMock : null);

  when(() => authMock.sendPasswordResetEmail(email: any(named: 'email')))
      .thenAnswer((_) async => true);

  when(() => authMock.signOut()).thenAnswer((_) async => setCurrentUser(null));

  when(() => authMock.createUserWithEmailAndPassword(
        email: any(named: 'email'),
        password: any(named: 'password'),
      )).thenAnswer((_) async => setCurrentUser(userMock));

  when(() => authMock.signInWithEmailAndPassword(
        email: any(named: 'email', that: isNot(equals('test@test.dev'))),
        password: any(named: 'password'),
      )).thenAnswer((_) async => setCurrentUser(null));
  when(() => authMock.signInWithEmailAndPassword(
        email: 'test@test.dev',
        password: any(named: 'password', that: isNot(equals('123'))),
      )).thenAnswer((_) async => setCurrentUser(null));
  when(() => authMock.signInWithEmailAndPassword(
        email: 'test@test.dev',
        password: '123',
      )).thenAnswer((_) async => setCurrentUser(userMock));

  return authMock;
}

Future<FirebaseFirestore> setupFirebaseFirestoreMock() async {
  final firestoreFake = FakeFirebaseFirestore();

  await firestoreFake.collection('userInfo').doc('test').set(
        const User(
          id: 'test',
          email: 'test@test.dev',
          cnpj: '00.000.000/0000-00',
          name: 'tester',
          address: 'test',
          city: 'test/TE',
          phoneNumber: '(00) 0000-0000',
          about: 'test',
          responsibleName: 'test',
          responsibleCpf: '000.000.000-00',
          isDonor: true,
          isBeneficiary: true,
          isAdmin: true,
          status: AuthorizationStatus.authorized,
        ).toMap(),
      );

  await firestoreFake.collection('userInfo').doc('anon').set(
        const User(
          id: 'anon',
          email: 'anon@test.dev',
          cnpj: '00.000.000/0000-00',
          name: 'anon',
          address: 'test',
          city: 'test/TE',
          phoneNumber: '(00) 0000-0000',
          about: 'test',
          responsibleName: 'test',
          responsibleCpf: '000.000.000-00',
          isDonor: true,
          isBeneficiary: true,
          isAdmin: true,
          status: AuthorizationStatus.authorized,
        ).toMap(),
      );

  await firestoreFake.collection('donation').add(
        Donation(
          description: 'Arroz',
          expiration: '01/01/5000',
          isDelivered: false,
          donorId: 'test',
          beneficiaryId: 'anon',
          createdAt: DateTime.now(),
        ).toMap(),
      );

  await firestoreFake.collection('donation').add(
        Donation(
          description: 'Carré',
          expiration: '01/01/5000',
          isDelivered: false,
          donorId: 'test',
          createdAt: DateTime.now(),
        ).toMap(),
      );

  await firestoreFake.collection('donation').add(
        Donation(
          description: 'Batata',
          expiration: '01/01/5000',
          isDelivered: false,
          donorId: 'anon',
          createdAt: DateTime.now(),
        ).toMap(),
      );

  await firestoreFake.collection('donation').add(
        Donation(
          description: 'Feijão',
          expiration: '01/01/5000',
          isDelivered: false,
          donorId: 'anon',
          beneficiaryId: 'test',
          createdAt: DateTime.now(),
        ).toMap(),
      );

  return firestoreFake;
}

Future<FirebaseStorage> setupFirebaseStorageMock() async {
  final storageMock = MockFirebaseStorage();

  final data = await rootBundle.load('assets/icon.png');
  final bytes = data.buffer.asUint8List();
  final tempDir = await getTemporaryDirectory();
  final file = await File('${tempDir.path}/tmp.tmp').writeAsBytes(bytes);
  await storageMock.ref().child('test.png').putFile(file);

  return storageMock;
}

Future<ImagePicker> setupImagePickerMock() async {
  const channel = MethodChannel('plugins.flutter.io/image_picker_android');

  Future<String> handler(MethodCall methodCall) async {
    final data = await rootBundle.load('assets/icon.png');
    final bytes = data.buffer.asUint8List();
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/tmp.tmp').writeAsBytes(bytes);
    return file.path;
  }

  TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, handler);

  return ImagePicker();
}
