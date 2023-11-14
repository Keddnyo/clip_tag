import 'package:flutter/material.dart';

IconData? getForumSectionIcon(String title) {
  final currentSection = {
    'Мультимедийные устройства': Icons.radio,
    'Носимые устройства': Icons.watch,
    'Автомобильные устройства': Icons.minor_crash,
    'Игровые кносоли': Icons.gamepad,
    'Квадрокоптеры': Icons.connecting_airports,
    'Кнопочные телефоны': Icons.dialpad,
    'Устройства для дома и развлечений': Icons.celebration,
    'Фото и Видео': Icons.image,
    'Электронные книги': Icons.menu_book,
    'Электротранспорт': Icons.airport_shuttle,
    'Компьютеры и периферия': Icons.devices,
    'Навигация': Icons.near_me,
    'Новинки': Icons.newspaper,
    'Книжная лавка': Icons.auto_stories,
    'Эмуляторы': Icons.computer,
    'Трепалка': Icons.psychology_alt,
    'Технотрепалка': Icons.psychology,
  }[title];

  if (currentSection != null) {
    return currentSection;
  }

  if (title.contains('Android')) {
    return Icons.android;
  }

  if (title.contains('Apple') || title.contains('iOS')) {
    return Icons.apple;
  }

  return Icons.double_arrow;
}
