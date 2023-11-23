import 'package:flutter/material.dart';

IconData getForumSectionIcon(String title) {
  final currentSection = {
    'Мультимедийные устройства': Icons.radio,
    'Носимые устройства': Icons.watch,
    'Автомобильные устройства': Icons.directions_car,
    'Игровые консоли': Icons.gamepad,
    'Квадрокоптеры': Icons.flight_takeoff,
    'Кнопочные телефоны': Icons.dialpad,
    'Устройства для дома и развлечений': Icons.celebration,
    'Фото и Видео': Icons.image,
    'Электронные книги': Icons.menu_book,
    'Электротранспорт': Icons.airport_shuttle,
    'Компьютеры и периферия': Icons.devices,
    'Навигация': Icons.near_me,
    'Новинки': Icons.new_releases,
    'Книжная лавка': Icons.auto_stories,
    'Эмуляторы': Icons.computer,
    'Трепалка': Icons.voice_chat,
    'Технотрепалка': Icons.psychology,
    'Барахолка': Icons.shopping_cart_outlined,
  }[title];

  if (currentSection != null) {
    return currentSection;
  }

  if (title.contains('Android')) {
    return Icons.android;
  }

  if (title.contains('Apple') || title.contains('iOS')) {
    return Icons.apple_sharp;
  }

  return Icons.double_arrow;
}
