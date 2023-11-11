import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../utils/copy_to_clipboard.dart';
import '../../../utils/open_url.dart';
import '../../../utils/show_snackbar.dart';
import '../model/forum_tags.dart';
import 'widgets/forum_tag.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.choosenRules});

  static const String route = '/checkout';
  final dynamic choosenRules;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isModerator = false;
  _setModerator(bool isModerator) => setState(() {
        _isModerator = isModerator;
      });

  int _currentTagIndex = 0;
  _setCurrentTagIndex(int index) => setState(() {
        _currentTagIndex = index;
      });

  ForumTags get _currentTag => ForumTags.values[_currentTagIndex];

  String get _wrapChoosenRulesWithTag {
    final buffer = StringBuffer();

    buffer
      ..write('[${_currentTag.closure}]\n')
      ..write('${widget.choosenRules}\n')
      ..write('[/${_currentTag.closure}]');

    return buffer.toString();
  }

  void _sendChoosenRules() {
    copyToClipboard(_wrapChoosenRulesWithTag);
    openUrl(Constants.fourpdaDefaultUrl);
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance.collection('users').snapshots().listen(
      (usersQuery) {
        final isModerator = usersQuery.docs.any((usersSnapshot) {
          final user = usersSnapshot.data();

          final email = user['email'];
          final isModerator = user['isModerator'];

          return email.trim() ==
                  FirebaseAuth.instance.currentUser?.email?.trim() &&
              isModerator;
        });

        if (_isModerator != isModerator) {
          _setModerator(isModerator);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Предпросмотр'),
        actions: [
          IconButton(
            onPressed: () {
              copyToClipboard(widget.choosenRules);
              showSnackbar(context: context, message: 'Текст скопирован');
            },
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            onPressed: _sendChoosenRules,
            icon: const Icon(Icons.send),
          ),
        ],
        shadowColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ForumTag(content: widget.choosenRules, tag: _currentTag),
        ),
      ),
      bottomNavigationBar: _isModerator
          ? NavigationBar(
              selectedIndex: _currentTagIndex,
              destinations: [
                for (final tag in ForumTags.values)
                  NavigationDestination(icon: Icon(tag.icon), label: tag.title),
              ],
              onDestinationSelected: (index) => _setCurrentTagIndex(index),
            )
          : null,
    );
  }
}
