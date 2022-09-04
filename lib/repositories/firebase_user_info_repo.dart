import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
import 'package:prodea/firebase/dtos/firebase_dto.dart';
import 'package:prodea/models/dtos/user_info_dto.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';
import 'package:prodea/services/contracts/notification_service.dart';

class FirebaseUserInfoRepo implements IUserInfoRepo {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final INotificationService notificationService;

  FirebaseUserInfoRepo(
    this.auth,
    this.firestore,
    this.notificationService,
  );

  CollectionReference get _collectionRef => firestore.collection('userInfo');

  @override
  Stream<List<UserInfo>> donorsInfo() {
    return _collectionRef
        .where('isDonor', isEqualTo: true)
        .where('status', isEqualTo: 1)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map((list) => list
            .map((userInfo) => userInfo.toMap())
            .map(UserInfoDTO.fromMap)
            .toList());
  }

  @override
  Stream<List<UserInfo>> beneficiariesInfo() {
    return _collectionRef
        .where('isBeneficiary', isEqualTo: true)
        .where('status', isEqualTo: 1)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map((list) => list
            .map((userInfo) => userInfo.toMap())
            .map(UserInfoDTO.fromMap)
            .toList());
  }

  @override
  Stream<List<UserInfo>> usersInfo() {
    return _collectionRef
        .where('isAdmin', isEqualTo: false)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs)
        .map((list) => list
            .map((userInfo) => userInfo.toMap())
            .map(UserInfoDTO.fromMap)
            .toList());
  }

  @override
  Future<UserInfo?> getCurrentUserInfo() async {
    final userId = auth.currentUser?.uid;

    if (userId != null) {
      try {
        final docRef = _collectionRef.doc(userId);
        final doc = await docRef.get();

        if (!doc.exists) {
          notificationService
              .notifyError('Usuário não possui dados cadastrais.');
          return null;
        }

        final map = doc.toMap();
        final userInfo = UserInfoDTO.fromMap(map);
        return userInfo;
      } catch (e) {
        notificationService
            .notifyError('Ocorreu um erro ao carregar os dados do usuário.');
      }
    } else {
      notificationService.notifyError('Usuário não autenticado.');
    }

    return null;
  }

  @override
  Future<UserInfo?> create(UserInfo userInfo) async {
    final userId = auth.currentUser?.uid;

    if (userId != null) {
      try {
        final docRef = _collectionRef.doc(userId);
        await docRef.set(userInfo.toMap());
        return userInfo;
      } catch (e) {
        notificationService
            .notifyError('Ocorreu um erro ao cadastrar a doação.');
      }
    } else {
      notificationService.notifyError('Usuário não autenticado.');
    }

    return null;
  }

  @override
  Future<void> setStatus(UserInfo userInfo, AuthorizationStatus status) async {
    try {
      final docRef = _collectionRef.doc(userInfo.id);
      final temp = userInfo.copyWith(status: status);
      docRef.set(temp.toMap());
    } catch (e) {
      notificationService
          .notifyError('Ocorreu um erro ao alterar o status do usuário');
    }
  }
}
