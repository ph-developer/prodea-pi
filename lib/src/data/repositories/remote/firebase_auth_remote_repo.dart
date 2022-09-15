import 'package:firebase_auth/firebase_auth.dart' hide UserInfo, User;

import '../../../domain/entities/user.dart';
import '../../../../core/errors/failures.dart';
import '../../../domain/repositories/auth_repo.dart';

class FirebaseAuthRemoteRepo implements IAuthRepo {
  final FirebaseAuth _auth;

  FirebaseAuthRemoteRepo(this._auth);

  @override
  Future<User> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return User(
          id: result.user!.uid,
          email: result.user!.email!,
        );
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-disabled':
          throw LoginFailure('O usuário informado está desativado.');
        case 'invalid-email':
        case 'user-not-found':
        case 'wrong-password':
          throw LoginFailure('Credenciais inválidas');
      }
    }
    throw LoginFailure();
  }

  @override
  Future<User> register(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        return User(
          id: result.user!.uid,
          email: result.user!.email!,
        );
      }
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
    }
    throw RegisterFailure();
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
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

  @override
  Future<bool> logout() async {
    try {
      await _auth.signOut();
      return true;
    } catch (e) {
      throw LoginFailure();
    }
  }

  @override
  Stream<User?> getCurrentUser() {
    return _auth.authStateChanges().map((user) {
      if (user == null) return null;

      return User(
        id: user.uid,
        email: user.email!,
      );
    });
  }
}
