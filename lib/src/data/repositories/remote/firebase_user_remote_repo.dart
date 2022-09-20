import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/user.dart';
import '../../dtos/firebase_dto.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/repositories/user_repo.dart';
import '../../dtos/user_dto.dart';

class FirebaseUserRemoteRepo implements IUserRepo {
  final FirebaseFirestore _firestore;

  FirebaseUserRemoteRepo(this._firestore);

  CollectionReference get _collectionRef => _firestore.collection('userInfo');

  @override
  Future<User> getById(String id) async {
    try {
      final docRef = _collectionRef.doc(id);
      final doc = await docRef.get();
      final userMap = doc.toMap();
      final user = UserDTO.fromMap(userMap);

      return user;
    } catch (e) {
      throw GetUserFailure();
    }
  }

  @override
  Future<User> create(User user) async {
    try {
      final docRef = _collectionRef.doc(user.id);
      await docRef.set(user.toMap());

      return user;
    } catch (e) {
      throw CreateUserFailure();
    }
  }

  @override
  Future<User> update(User user) async {
    try {
      final docRef = _collectionRef.doc(user.id);
      docRef.set(user.toMap());

      return user;
    } catch (e) {
      throw UpdateUserFailure();
    }
  }

  @override
  Stream<List<User>> getUsers() {
    return _collectionRef.snapshots().map((snapshot) => snapshot.docs).map(
        (list) =>
            list.map((user) => user.toMap()).map(UserDTO.fromMap).toList());
  }
}
