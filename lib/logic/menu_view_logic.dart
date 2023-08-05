import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';

class MenuViewLogic {
  late Map allTimeMenus;
  late Map meals;

  MenuViewLogic() {
    allTimeMenus = MenuStoragePreferences.getAllTimeMenusPerWeek();
    meals = MenuStoragePreferences.getMeals();
  }

  List getWeeklyMenu(DateTime startDate) {
    if (allTimeMenus.containsKey(startDate.toString())) {
      return allTimeMenus[startDate.toString()];
    }
    List menu = [];
    if (meals.length > 0) {
      for (int i = 0; i < 7; i++) {
        menu.add(meals.keys.toList()[Random().nextInt(meals.length)]);
      }
      return menu;
    }
    return ["", "", "", "", "", "", ""];
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
    List allTimeMenusKeys = allTimeMenus.keys.toList();
    int indexOfDtNow =
        allTimeMenusKeys.indexOf(setDateToMonday(dtNow).toString());
    if (indexOfDtNow >= 0) {
      return indexOfDtNow;
    } else {
      return allTimeMenusKeys.length;
    }
  }

  void deleteMenu(double? page) {
    List allTimeMenusKeys = allTimeMenus.keys.toList();
    String toDelete = allTimeMenusKeys[page!.toInt()];
    allTimeMenus.remove(toDelete);
    MenuStoragePreferences.setAllTimeMenusPerWeek(allTimeMenus);
  }

  void createMenu() {
    final dtNextWeek =
        DateUtils.dateOnly(DateTime.now().add(Duration(days: 7)));
    List weeklyMenu = getWeeklyMenu(setDateToMonday(dtNextWeek));
    allTimeMenus[setDateToMonday(dtNextWeek).toString()] = weeklyMenu;
    //allTimeMenus.remove(createMenu.setStartDateToMonday(dtNextWeek).toString());
    MenuStoragePreferences.setAllTimeMenusPerWeek(allTimeMenus);
  }
}
