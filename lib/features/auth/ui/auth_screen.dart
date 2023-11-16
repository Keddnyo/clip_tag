import 'package:flutter/material.dart';

import '../../../shared/firebase_controller.dart';
import 'controllers/auth_screen_controller.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  static const String route = '/login';

  @override
  Widget build(BuildContext context) {
    final firebaseController = FirebaseProvider.of(context);
    final authController = AuthScreenController(firebaseController);

    return WillPopScope(
      onWillPop: () async {
        if (!authController.isSignIn) {
          authController.switchToSignIn();
          return false;
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ClipTag ID'),
        ),
        body: Form(
          key: authController.formKey,
          child: SingleChildScrollView(
            child: ListenableBuilder(
              listenable: authController,
              builder: (context, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (authController.isSignUp)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: authController.usernameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.account_circle_outlined),
                          labelText: 'Ник на 4PDA',
                          hintText: 'Ваш ник на 4PDA',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.name,
                        validator: (username) => username?.isEmpty == true
                            ? 'Введите свой ник на 4PDA'
                            : null,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: authController.emailController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Почта',
                        hintText: 'example@domain.com',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (email) =>
                          email?.isEmpty == true ? 'Введите свою почту' : null,
                    ),
                  ),
                  if (!authController.isPasswordReset)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: authController.passwordController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.password),
                          labelText: 'Пароль',
                          hintText: authController.isSignUp
                              ? 'Не менее 6 символов'
                              : null,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (password) => password?.isEmpty == true
                            ? 'Пароль не должен быть пустым'
                            : null,
                      ),
                    ),
                  if (authController.isSignUp)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: authController.confirmPasswordController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          labelText: 'Подтвердите пароль',
                          hintText: 'Пароли должны совпадать',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        validator: (confirmPassword) =>
                            confirmPassword != authController.password
                                ? 'Пароли должны совпадать'
                                : null,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilledButton.icon(
                      onPressed: () => authController.submitAuth(
                        context: context,
                      ),
                      icon: Icon(authController.submitButtonIcon),
                      label: Text(authController.submitButtonTitle),
                    ),
                  ),
                  if (!authController.isSignUp)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        onPressed: authController.switchPasswordReset,
                        icon: Icon(authController.resetPasswordButtonIcon),
                        label: Text(authController.resetPasswordButtonTitle),
                      ),
                    ),
                  if (!authController.isPasswordReset)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton.icon(
                        onPressed: authController.switchSignUp,
                        icon: Icon(authController.signUpButtonIcon),
                        label: Text(authController.signUpButtonTitle),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
