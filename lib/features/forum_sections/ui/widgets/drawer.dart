part of '../forum_sections_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final firebase = FirebaseProvider.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Constants.appName,
                    style: TextStyle(fontSize: 42.0),
                  ),
                  Text(
                    'Created by Keddnyo',
                    style: TextStyle(fontSize: 10.0),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: Text(firebase.username!),
            subtitle: Text(firebase.userEmail!),
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(firebase.username!),
                content: Text(firebase.userEmail!),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      firebase
                          .deleteAccount()
                          .then(
                            (_) => showSnackbar(
                                context: context, message: 'Аккаунт удалён'),
                          )
                          .catchError(
                            (error) => showSnackbar(
                              context: context,
                              message: error is FirebaseAuthException
                                  ? decodeFirebaseAuthErrorCode(error.code)
                                  : error.toString(),
                            ),
                          );
                    },
                    child: const Text('Удалить аккаунт'),
                  ),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      firebase.signOut();
                    },
                    child: const Text('Выход'),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.bookmark_outline),
            title: const Text('Избранное'),
            subtitle: Text('${firebase.userFavoritesCount} элементов'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, FavoritesScreen.route);
            },
          ),
          const Divider(),
          AboutListTile(
            icon: const Icon(Icons.info_outline),
            applicationVersion: 'Агрегатор правил 4PDA',
            applicationIcon: Image.asset(
              'lib/core/assets/app_icon.png',
              width: 72.0,
              height: 72.0,
            ),
            applicationLegalese: Constants.applicationLegalese,
            child: const Text('О приложении'),
          ),
        ],
      ),
    );
  }
}
