import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Color globalMainColor = Colors.purple;
Color globalAccentColor = Colors.purpleAccent;

class MenuStoragePreferences {
  static late SharedPreferences _preferences;
  static const allTimeMenuKey = "menuList";
  static const mealKey = "meal";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setAllTimeMenusPerWeek(Map menuList) async {
    final strAllTimeMenusPerWeek = json.encode(menuList);
    await _preferences.setString(allTimeMenuKey, strAllTimeMenusPerWeek);
  }

  static Map getAllTimeMenusPerWeek() {
    final allTimeMenusPerWeek = _preferences.getString(allTimeMenuKey) ?? "";
    if (allTimeMenusPerWeek != "") {
      return json.decode(allTimeMenusPerWeek);
    } else {
      return {};
    }
  }

  static Future setMeals(Map meals) async {
    final strMeals = json.encode(meals);
    await _preferences.setString(mealKey, strMeals);
  }

  static Future addMeal(Map meal) async {
    final strMeals = json.encode(meal);
    await _preferences.setString(mealKey, strMeals);
  }

  static Map getMeals() {
    var meals = _preferences.getString(mealKey) ?? "";
    if (meals != "") {
      return json.decode(meals);
    }
    return {};
  }
}
