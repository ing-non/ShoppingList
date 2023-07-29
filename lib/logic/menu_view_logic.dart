import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';

class MenuViewLogic
{
  late Map _allTimeMenus;
  late List<String>? meals;

  MenuViewLogic(Map allTimeMenus)
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

  DateTime setStartDateToMonday(DateTime startDate) {
    while (true) {
      if (startDate.weekday != 1) {
        startDate = startDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return startDate;
  }

  int getIndexOfCurrentWeekFromAllTimeMenus()
  {
    DateTime dtNow = DateUtils.dateOnly(DateTime.now());
    List allTimeMenusKeys = _allTimeMenus.keys.toList();
    int indexOfDtNow = allTimeMenusKeys.indexOf(setStartDateToMonday(dtNow).toString());
    if (indexOfDtNow >= 0)
    {
      return indexOfDtNow;
    }
    else{
      return allTimeMenusKeys.length;
    }
  }

}