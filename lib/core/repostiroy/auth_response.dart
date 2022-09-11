import '../models/user_model.dart';

class AuthRepsonse<T> {
  final bool isSuccessful;
  final String message;
  final T? data;
  final UserModel? userData;

  AuthRepsonse(
      {required this.isSuccessful,
      required this.message,
      this.data,
      this.userData});
}