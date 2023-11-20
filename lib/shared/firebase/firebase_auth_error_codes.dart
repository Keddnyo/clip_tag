String decodeFirebaseAuthErrorCode(String code) =>
    {
      'invalid-email': 'Неверный логин',
      'INVALID_LOGIN_CREDENTIALS': 'Неверный логин или пароль',
      'email-already-in-use': 'Аккаунт уже зарегистрирован',
      'weak-password': 'Нужен надёжный пароль',
      'too-many-requests': 'Повторите попытку позже',
      'user-disabled': 'Аккаунт заблокирован',
    }[code] ??
    code;
