import 'package:imc_calc/utils/db_helper.dart';

class AuthController {
  Future<int> login(String email, String password) async {
    final user = await DatabaseHelper.instance.getUserByEmail(email);

    if (user == null) {
      throw Exception('Usuário e/ou Senha incorretas');
    }

    if (user[DatabaseHelper.columnPassword] != password) {
      throw Exception('Usuário e/ou Senha incorretas');
    }

    final userId = user[DatabaseHelper.columnUserId] as int;

    await DatabaseHelper.instance.logoutAllUsers();
    await DatabaseHelper.instance.setUserLoggedIn(userId);

    return userId;
  }

  Future<void> register(String email, String name, String password) async {
    final existing = await DatabaseHelper.instance.getUserByEmail(email);
    if (existing != null) throw Exception('E-mail já cadastrado');

    await DatabaseHelper.instance.insertUser(
      email: email,
      name: name,
      password: password,
    );
  }
}
