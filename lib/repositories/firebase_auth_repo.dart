import 'package:firebase_auth/firebase_auth.dart' hide UserInfo, User;
import 'package:prodea/models/user.dart';
import 'package:prodea/models/user_info.dart';
import 'package:prodea/repositories/contracts/auth_repo.dart';
import 'package:prodea/repositories/contracts/user_info_repo.dart';
import 'package:prodea/services/contracts/notification_service.dart';

class FirebaseAuthRepo implements IAuthRepo {
  final FirebaseAuth auth;
  final IUserInfoRepo userInfoRepo;
  final INotificationService notificationService;

  FirebaseAuthRepo(
    this.auth,
    this.userInfoRepo,
    this.notificationService,
  );

  @override
  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      notificationService.notifyError('Credenciais inválidas.');
      return false;
    }

    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-disabled':
          notificationService.notifyError('O usuário foi desabilitado.');
          break;
        case 'invalid-email':
          notificationService
              .notifyError('O email informado possui um formato inválido.');
          break;
        case 'user-not-found':
          notificationService.notifyError('Usuário não encontrado.');
          break;
        case 'wrong-password':
          notificationService.notifyError('Senha incorreta.');
          break;
        default:
          notificationService.notifyError('Ocorreu um erro inesperado.');
          break;
      }
    } catch (e) {
      notificationService.notifyError('Ocorreu um erro inesperado.');
    }

    return false;
  }

  @override
  Future<bool> register(
    String email,
    String password,
    UserInfo userInfo,
  ) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userInfoRepo.create(userInfo);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          notificationService.notifyError('O email informado já está em uso.');
          break;
        case 'invalid-email':
          notificationService
              .notifyError('O email informado possui um formato inválido.');
          break;
        case 'operation-not-allowed':
          notificationService.notifyError('Operação não permitida.');
          break;
        case 'weak-password':
          notificationService.notifyError('A senha informada é muito fraca.');
          break;
        default:
          notificationService.notifyError('Ocorreu um erro inesperado.');
          break;
      }
    } catch (e) {
      notificationService.notifyError('Ocorreu um erro inesperado.');
    }

    return false;
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'auth/invalid-email':
          notificationService
              .notifyError('O email informado possui um formato inválido.');
          break;
        case 'auth/user-not-found':
          notificationService
              .notifyError('O email informado não possui cadastro.');
          break;
        case 'auth/missing-android-pkg-name':
        case 'auth/missing-ios-bundle-id':
        case 'auth/missing-continue-uri':
        case 'auth/invalid-continue-uri':
        case 'auth/unauthorized-continue-uri':
          notificationService.notifyError('Ocorreu um erro interno.');
          break;
        default:
          notificationService.notifyError('Ocorreu um erro inesperado.');
          break;
      }
    } catch (e) {
      notificationService.notifyError('Ocorreu um erro inesperado.');
    }

    return false;
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Stream<User?> authStateChanged() {
    return auth.authStateChanges().map((user) {
      if (user == null) return null;

      return User(
        id: user.uid,
        email: user.email!,
      );
    });
  }
}
