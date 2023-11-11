import 'package:flutter/material.dart';

enum ForumTags {
  cur(
    title: 'Куратор',
    leadingSymbol: 'K',
    closure: 'cur',
    lightColor: Color(0xFF00943B),
    darkColor: Color(0xFF004F1F),
    icon: Icons.menu_book,
  ),
  mod(
    title: 'Модератор',
    leadingSymbol: 'M',
    closure: 'mod',
    lightColor: Color(0xFF6060FF),
    darkColor: Color(0xFF3B3F9F),
    icon: Icons.local_police_outlined,
  ),
  ex(
    title: 'Нарушение',
    leadingSymbol: '!',
    closure: 'ex',
    lightColor: Color(0xFFFF6060),
    darkColor: Color(0xFF9F3B3B),
    icon: Icons.gavel,
  );

  const ForumTags({
    required this.title,
    required this.leadingSymbol,
    required this.closure,
    required this.lightColor,
    required this.darkColor,
    required this.icon,
  });

  final String title;
  final String leadingSymbol;
  final String closure;
  final Color lightColor;
  final Color darkColor;
  final IconData icon;
}
