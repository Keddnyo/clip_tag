import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../shared/firebase/firebase_auth_error_codes.dart';
import '../../../shared/ui/show_snackbar.dart';
import '../../../utils/open_url.dart';
import 'controllers/auth_screen_controller.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthScreenProvider.of(context);

    void submit() {
      if (auth.formKey.currentState?.validate() == false) {
        return;
      }

      auth.submitAuth().then(
        (value) {
          if (auth.isResetPassword) {
            auth.setSignIn();
            showSnackbar(
              context: context,
              message: 'Ссылка отправлена на почту',
            );
          }
        },
      ).catchError(
        (error) {
          showSnackbar(
            context: context,
            message: error is FirebaseAuthException
                ? decodeFirebaseAuthErrorCode(error.code)
                : error.toString(),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: !auth.isSignIn
            ? IconButton(
                onPressed: Navigator.of(context).maybePop,
                icon: const Icon(Icons.arrow_back),
              )
            : null,
        title: Text(
          auth.isResetPassword
              ? 'Сброс пароля'
              : auth.isSignUp
                  ? 'Новый ${Constants.appName} ID'
                  : '${Constants.appName} ID',
        ),
        shadowColor: Colors.black,
      ),
      body: Form(
        key: auth.formKey,
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints.tightFor(width: 512.0),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: auth.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Почта',
                        hintText: 'example@domain.com',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: auth.isResetPassword
                          ? TextInputAction.done
                          : TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          auth.isResetPassword ? submit() : null,
                      validator: (email) =>
                          email?.isEmpty == true ? 'Введите почту' : null,
                      autofillHints: const [AutofillHints.email],
                    ),
                    if (!auth.isResetPassword)
                      TextFormField(
                        controller: auth.passwordController,
                        decoration: InputDecoration(
                          labelText: 'Пароль',
                          hintText:
                              auth.isSignUp ? 'Не менее 6 символов' : null,
                          prefixIcon: const Icon(Icons.password),
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: auth.isSignUp
                            ? TextInputAction.next
                            : TextInputAction.done,
                        obscureText: true,
                        onFieldSubmitted: (_) =>
                            !auth.isSignUp ? submit() : null,
                        validator: (password) => password?.isEmpty == true
                            ? 'Пароль не должен быть пустым'
                            : null,
                        autofillHints: [
                          auth.isSignUp
                              ? AutofillHints.newPassword
                              : AutofillHints.password
                        ],
                      ),
                    if (auth.isSignUp)
                      TextFormField(
                        controller: auth.confirmPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Подтвердите пароль',
                          hintText: 'Пароли должны совпадать',
                          prefixIcon: Icon(Icons.password),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        validator: (confirmPassword) =>
                            confirmPassword?.isEmpty == true ||
                                    confirmPassword != auth.password
                                ? 'Пароли должны совпадать'
                                : null,
                        autofillHints: const [AutofillHints.newPassword],
                      ),
                    if (auth.isSignUp)
                      TextFormField(
                        controller: auth.usernameController,
                        decoration: const InputDecoration(
                          labelText: 'Имя пользователя',
                          hintText: 'Ваше имя или никнейм',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => submit(),
                        validator: (username) => username?.isEmpty == true
                            ? 'Введите свой ник на 4PDA'
                            : null,
                        autofillHints: const [AutofillHints.name],
                      ),
                    FilledButton.icon(
                      onPressed: submit,
                      icon: Icon(
                        auth.isSignUp
                            ? Icons.person_add
                            : auth.isResetPassword
                                ? Icons.password
                                : Icons.login,
                      ),
                      label: Text(
                        auth.isSignUp
                            ? 'Создать аккаунт'
                            : auth.isResetPassword
                                ? 'Сбросить пароль'
                                : 'Войти',
                      ),
                    ),
                    if (auth.isSignIn)
                      OutlinedButton.icon(
                        onPressed: auth.setResetPassword,
                        icon: const Icon(Icons.password),
                        label: const Text('Забыли пароль?'),
                      ),
                    if (auth.isSignIn)
                      TextButton.icon(
                        onPressed: auth.signInAnonymously,
                        icon: const Icon(Icons.person_search),
                        label: const Text('Продолжить как гость'),
                      ),
                    if (auth.isSignUp)
                      TextButton.icon(
                        onPressed: () => openUrl(Constants.appTermsOfUseUrl),
                        icon: const Icon(Icons.gavel),
                        label: const Text('Условия использования'),
                      ),
                  ]
                      .map(
                        (child) => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 12.0,
                          ),
                          child: child,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          if (!auth.isSignIn) {
            auth.setSignIn();
            return false;
          }

          return true;
        },
      ),
      floatingActionButton: auth.isSignIn
          ? FloatingActionButton.extended(
              onPressed: auth.setSignUp,
              icon: const Icon(Icons.person_add),
              label: const Text('Создать аккаунт'),
            )
          : null,
    );
  }
}
