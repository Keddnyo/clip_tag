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
            title: Text(firebase.username ?? 'Режим гостя'),
            subtitle: firebase.userEmail != null
                ? Text(
                    firebase.userEmail!,
                  )
                : null,
            trailing: IconButton(
              onPressed: () {
                Navigator.pop(context);
                firebase.signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.gavel),
            title: const Text('Условия использования'),
            onTap: () => openUrl(Constants.appTermsOfUseUrl),
          ),
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
