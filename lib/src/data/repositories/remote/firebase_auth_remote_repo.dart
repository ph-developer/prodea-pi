import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/failures.dart';
import '../../../domain/repositories/auth_repo.dart';

class FirebaseAuthRemoteRepo implements IAuthRepo {
  final FirebaseAuth _auth;

  FirebaseAuthRemoteRepo(this._auth);

  @override
  Future<String> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) return result.user!.uid;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-disabled':
          throw LoginFailure('O usuário informado está desativado.');
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
          throw LoginFailure('Credenciais inválidas');
      }
    } catch (e) {
      throw LoginFailure();
    }
    throw LoginFailure();
  }

  @override
  Future<String> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) return result.user!.uid;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw RegisterFailure('O email informado já está em uso.');
        case 'invalid-email':
          throw RegisterFailure(
            'O email informado possui um formato inválido.',
          );
        case 'weak-password':
          throw RegisterFailure('A senha informada é muito fraca.');
      }
    } catch (e) {
      throw RegisterFailure();
    }
    throw RegisterFailure();
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'auth/invalid-email':
            throw PasswordResetFailure(
              'O email informado possui um formato inválido.',
            );
          case 'auth/user-not-found':
            throw PasswordResetFailure(
              'O email informado não possui cadastro.',
            );
        }
      }
      throw PasswordResetFailure();
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      throw LogoutFailure();
    }
  }

  @override
  Future<String?> getCurrentUserId() async {
    var user = _auth.currentUser;

    user ??= await _auth.authStateChanges().first;

    return user?.uid;
  }

  @override
  Stream<String?> currentUserIdChanged() {
    return _auth.authStateChanges().map((user) {
      return user?.uid;
    });
  }
}
