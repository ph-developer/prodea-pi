import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/user_info.dart';
import '../../dtos/firebase_dto.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/repositories/user_info_repo.dart';
import '../../dtos/user_info_dto.dart';

class FirebaseUserInfoRemoteRepo implements IUserInfoRepo {
  final FirebaseFirestore _firestore;

  FirebaseUserInfoRemoteRepo(this._firestore);

  CollectionReference get _collectionRef => _firestore.collection('userInfo');

  @override
  Future<UserInfo> getById(String id) async {
    try {
      final docRef = _collectionRef.doc(id);
      final doc = await docRef.get();
      final userInfoMap = doc.toMap();
      final userInfo = UserInfoDTO.fromMap(userInfoMap);

      return userInfo;
    } catch (e) {
      throw GetUserInfoFailure();
    }
  }

  @override
  Future<UserInfo> create(UserInfo userInfo) async {
    try {
      final docRef = _collectionRef.doc(userInfo.id);
      await docRef.set(userInfo.toMap());

      return userInfo;
    } catch (e) {
      throw CreateUserInfoFailure();
    }
  }

  @override
  Future<UserInfo> update(UserInfo userInfo) async {
    try {
      final docRef = _collectionRef.doc(userInfo.id);
      docRef.set(userInfo.toMap());

      return userInfo;
    } catch (e) {
      throw UpdateUserInfoFailure();
    }
  }

  @override
  Stream<List<UserInfo>> getUserInfos() {
    return _collectionRef.snapshots().map((snapshot) => snapshot.docs).map(
        (list) => list
            .map((userInfo) => userInfo.toMap())
            .map(UserInfoDTO.fromMap)
            .toList());
  }
}
