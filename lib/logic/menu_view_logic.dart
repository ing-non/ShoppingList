import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'package:test_app/logic/models/meal.dart';
import 'package:test_app/logic/models/menu.dart';
import 'package:test_app/services/mealRepository.dart';
import 'package:test_app/services/menuRepository.dart';

class MenuViewLogic {
  MenuRepository menuRepository = MenuRepository();
  MealRepository mealRepository = MealRepository();

  MenuViewLogic() {}

  DateTime _setDateToMonday(DateTime date) {
    while (true) {
      if (date.weekday != 1) {
        date = date.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return date;
  }

  Future<int> getIndexOfCurrentWeekFromMenus() async {
    DateTime dtNow = DateUtils.dateOnly(_setDateToMonday(DateTime.now()));
    QuerySnapshot snapshot = await menuRepository.getAllMenus();
    Map<String, dynamic> menu = {};
    int i = 0;
    for (var doc in snapshot.docs) {
      menu = doc.data() as Map<String, dynamic>;
      DateTime menuStartDate = menu["startDate"].toDate();
      if (menuStartDate.day == dtNow.day &&
          menuStartDate.month == dtNow.month &&
          menuStartDate.year == dtNow.year) {
        return i;
      }
      i++;
    }
    return 0;
  }

  Future<bool> _checkIfMenuForThisWeekExists(DateTime startDate) async {
    QuerySnapshot snapshot = await menuRepository.getAllMenus();
    try {
      DocumentSnapshot latestMenuSnapshot = snapshot.docs[0];
      Map<String, dynamic> latestMenu =
          latestMenuSnapshot.data() as Map<String, dynamic>;
      DateTime startDateOfLatestMenu = latestMenu["startDate"].toDate();
      if (startDate == startDateOfLatestMenu) {
        return false;
      }
    } catch (exception) {
      return true;
    }

    return true;
  }

  void createMenu() async {
    Map<String, dynamic> allMeals = {};
    List<String> weeklyMeals = <String>[];
    QuerySnapshot snapshot = await mealRepository.getAllMeals();

    for (var doc in snapshot.docs) {
      allMeals[doc.id] = doc.data() as Map<String, dynamic>;
    }

    for (int i = 0; i < 7; i++) {
      String id = allMeals.keys.toList()[Random().nextInt(allMeals.length)];
      weeklyMeals.add(id);
    }
    final todayNextWeek =
        DateUtils.dateOnly(DateTime.now().add(const Duration(days: 7)));
    final nextMonday = _setDateToMonday(todayNextWeek);

    Menu menu = Menu(
        startDate: nextMonday,
        endDate: nextMonday.add(const Duration(days: 6)),
        weeklyMeals);

    if (await _checkIfMenuForThisWeekExists(nextMonday)) {
      menuRepository.addMenu(menu);
    }
  }
}
