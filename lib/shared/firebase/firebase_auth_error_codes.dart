String decodeFirebaseAuthErrorCode(String code) =>
    {
      'invalid-email': 'Неверный логин',
      'INVALID_LOGIN_CREDENTIALS': 'Неверный логин или пароль',
      'invalid-login-credentials': 'Неверный логин или пароль',
      'invalid-credential': 'Неверный логин или пароль',
      'email-already-in-use': 'Аккаунт уже зарегистрирован',
      'weak-password': 'Используйте надёжный пароль',
      'too-many-requests': 'Повторите попытку позже',
      'user-disabled': 'Аккаунт заблокирован',
      'network-request-failed': 'Ошибка подключения к сети',
      'operation-not-allowed': 'Недопустимое действие',
    }[code] ??
    code;
