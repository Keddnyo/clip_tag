String decodeFirebaseAuthErrorCode(String code) =>
    {
      'invalid-email': 'Неверный логин',
      'invalid_login_credentials': 'Неверный логин или пароль',
      'email-already-in-use': 'Аккаунт уже зарегистрирован',
      'weak-password': 'Используйте надёжный пароль',
      'too-many-requests': 'Повторите попытку позже',
      'user-disabled': 'Аккаунт заблокирован',
      'network-request-failed': 'Ошибка подключения к сети',
    }[code] ??
    code;
