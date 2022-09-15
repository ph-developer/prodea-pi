import '../../domain/entities/user.dart';

extension UserDTO on User {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
    );
  }
}
