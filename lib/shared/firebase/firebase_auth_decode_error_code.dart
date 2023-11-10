import 'firebase_auth_error_codes.dart';

String decodeFirebaseAuthErrorCode(String code) {
  switch (code) {
    case FirebaseAuthErrorCodes.invalidCredentials:
      {
        return 'Неверный логин или пароль';
      }
    case FirebaseAuthErrorCodes.invalidEmail:
      {
        return 'Неверная почта';
      }
    case FirebaseAuthErrorCodes.emailAlreadyInUse:
      {
        return 'Аккаунт с такой почтой уже существует';
      }
    case FirebaseAuthErrorCodes.tooManyRequests:
      {
        return 'Слишком много запросов';
      }
    default:
      {
        return 'Неизвестная ошибка';
      }
  }
}
