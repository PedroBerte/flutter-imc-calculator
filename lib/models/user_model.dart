class UserModel {
  final int userId;
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'email': email,
      'name': name,
      'password': password,
    };
  }
}
