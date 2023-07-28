import 'dart:math';

import 'package:test_app/globals.dart';

class CreateNewMenu
{
  late Map _allTimeMenus;
  late List<String>? meals;

  CreateNewMenu(Map allTimeMenus)
  {
    _allTimeMenus = allTimeMenus;
    meals = MenuStoragePreferences.getMeals();
  }

  List getWeeklyMenu(DateTime startDate)
  {
    if (_allTimeMenus.containsKey(startDate.toString()))
    {
      return _allTimeMenus[startDate.toString()];
    }
    List menu = [];
    for (int i = 0; i < 7; i++) {
      menu.add(meals![Random().nextInt(7)]);
    }
    return menu;
  }
}