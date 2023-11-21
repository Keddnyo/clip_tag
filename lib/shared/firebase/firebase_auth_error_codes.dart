String decodeFirebaseAuthErrorCode(String code) =>
    {
      'invalid-email': 'Неверный логин',
      'INVALID_LOGIN_CREDENTIALS': 'Неверный логин или пароль',
      'email-already-in-use': 'Аккаунт уже зарегистрирован',
      'weak-password': 'Используйте надёжный пароль',
      'too-many-requests': 'Повторите попытку позже',
      'requires-recent-login':
          'Требуется повторная авторизация', // TODO: Maybe remove
      'user-disabled': 'Аккаунт заблокирован',
      'network-request-failed': 'Ошибка подключения к сети',
    }[code] ??
    code;
