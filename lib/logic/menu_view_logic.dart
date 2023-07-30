import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';

class MenuViewLogic {
  late Map _allTimeMenus;
  late Map? meals;

  MenuViewLogic(Map allTimeMenus) {
    _allTimeMenus = allTimeMenus;
    meals = MenuStoragePreferences.getMeals();
  }

  List getWeeklyMenu(DateTime startDate) {
    if (_allTimeMenus.containsKey(startDate.toString())) {
      return _allTimeMenus[startDate.toString()];
    }
    List menu = [];
    for (int i = 0; i < 7; i++) {
      menu.add(meals!.keys.toList()[Random().nextInt(meals!.length)]);
    }
    return menu;
  }

  DateTime setDateToMonday(DateTime date) {
    while (true) {
      if (date.weekday != 1) {
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return date;
  }

  int getIndexOfCurrentWeekFromAllTimeMenus() {
    DateTime dtNow = DateUtils.dateOnly(DateTime.now());
    List allTimeMenusKeys = _allTimeMenus.keys.toList();
    int indexOfDtNow =
        allTimeMenusKeys.indexOf(setDateToMonday(dtNow).toString());
    if (indexOfDtNow >= 0) {
      return indexOfDtNow;
    } else {
      return allTimeMenusKeys.length;
    }
  }

  void deleteMenu(double? page) {
    List allTimeMenusKeys = _allTimeMenus.keys.toList();
    String toDelete = allTimeMenusKeys[page!.toInt()];
    _allTimeMenus.remove(toDelete);
    MenuStoragePreferences.setAllTimeMenusPerWeek(_allTimeMenus);
  }

  void createMenu() {
    final dtNextWeek =
        DateUtils.dateOnly(DateTime.now().subtract(Duration(days: -8)));
    MenuViewLogic menuViewLogic = MenuViewLogic(_allTimeMenus);
    List weeklyMenu =
        menuViewLogic.getWeeklyMenu(menuViewLogic.setDateToMonday(dtNextWeek));
    _allTimeMenus[menuViewLogic.setDateToMonday(dtNextWeek).toString()] =
        weeklyMenu;
    //allTimeMenus.remove(createMenu.setStartDateToMonday(dtNextWeek).toString());
    MenuStoragePreferences.setAllTimeMenusPerWeek(_allTimeMenus);
  }
}
