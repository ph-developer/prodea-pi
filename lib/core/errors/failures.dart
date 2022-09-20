abstract class Failure implements Exception {
  final String message;
  Failure(this.message);
}

class LoginFailure extends Failure {
  LoginFailure([
    String message = 'Ocorreu um erro ao efetuar o login.',
  ]) : super(message);
}

class RegisterFailure extends Failure {
  RegisterFailure([
    String message = 'Ocorreu um erro ao cadastrar o usuário.',
  ]) : super(message);
}

class PasswordResetFailure extends Failure {
  PasswordResetFailure([
    String message = 'Ocorreu um erro ao solicitar a redefinição da senha.',
  ]) : super(message);
}

class LogoutFailure extends Failure {
  LogoutFailure([
    String message = 'Ocorreu um erro ao efetuar o logout.',
  ]) : super(message);
}

class UploadFileFailure extends Failure {
  UploadFileFailure([
    String message = 'Ocorreu um erro ao fazer o upload do arquivo.',
  ]) : super(message);
}

class GetFileDownloadUrlFailure extends Failure {
  GetFileDownloadUrlFailure([
    String message = 'Ocorreu um erro ao fazer o download do arquivo.',
  ]) : super(message);
}

class CreateDonationFailure extends Failure {
  CreateDonationFailure([
    String message = 'Ocorreu um erro ao postar a doação.',
  ]) : super(message);
}

class UpdateDonationFailure extends Failure {
  UpdateDonationFailure([
    String message = 'Ocorreu um erro ao alterar a doação.',
  ]) : super(message);
}

class GetUserFailure extends Failure {
  GetUserFailure([
    String message =
        'Ocorreu um erro ao carregar os dados cadastrais do usuário.',
  ]) : super(message);
}

class CreateUserFailure extends Failure {
  CreateUserFailure([
    String message =
        'Ocorreu um erro ao salvar os dados cadastrais do usuário.',
  ]) : super(message);
}

class UpdateUserFailure extends Failure {
  UpdateUserFailure([
    String message =
        'Ocorreu um erro ao atualizar os dados cadastrais do usuário.',
  ]) : super(message);
}

class InternetConnectionFailure extends Failure {
  InternetConnectionFailure([
    String message = 'Sem conexão com a internet.',
  ]) : super(message);
}

class PhotoPickFailure extends Failure {
  PhotoPickFailure([
    String message = 'Ocorreu um erro ao carregar a foto.',
  ]) : super(message);
}
