import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
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
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'auth/user-not-found':
          notificationService.notifyError('Usuário não encontrado.');
          break;
        case 'auth/wrong-password':
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
        case 'auth/email-already-in-use':
          notificationService.notifyError('O email informado já está em uso.');
          break;
        case 'auth/invalid-email':
          notificationService
              .notifyError('O email informado possui um formato inválido.');
          break;
        case 'auth/operation-not-allowed':
          notificationService.notifyError('Operação não permitida.');
          break;
        case 'auth/weak-password':
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
  Future<void> logout() async {
    await auth.signOut();
  }
}
