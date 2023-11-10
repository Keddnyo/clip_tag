import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../shared/constants.dart';
import '../../../utils/copy_to_clipboard.dart';
import '../../../utils/open_url.dart';
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
        var isModerator = usersQuery.docs.any(
            (usersSnapshot) => usersSnapshot.data()['isModerator'] == true);

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
        title: const Text('Checkout'),
        actions: [
          IconButton(
            onPressed: () => copyToClipboard(widget.choosenRules),
            icon: const Icon(Icons.copy),
          ),
          IconButton(
            onPressed: _sendChoosenRules,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: ForumTag(content: widget.choosenRules, tag: _currentTag),
      bottomNavigationBar: _isModerator
          ? NavigationBar(
              selectedIndex: _currentTagIndex,
              destinations: [
                for (final tag in ForumTags.values)
                  NavigationDestination(
                    icon: Icon(tag.icon),
                    label: tag.closure.toUpperCase(),
                  ),
              ],
              onDestinationSelected: (index) => _setCurrentTagIndex(index),
            )
          : null,
    );
  }
}
