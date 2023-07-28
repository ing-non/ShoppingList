import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ShoppingListPreferences {
  static late SharedPreferences _preferences;
  static const shoppingListKey = "shoppingList";
  static const shoppingListItemKey = "shoppingListItem";

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setShoppingLists(Map shoppingLists) async {
    final strShoppingList = json.encode(shoppingLists);
    await _preferences.setString(shoppingListKey, strShoppingList);
  }

  static Map getShoppingLists() {
    final shoppingLists = _preferences.getString(shoppingListKey) ?? "";
    if (shoppingLists != "") {
      return json.decode(shoppingLists);
    } else {
      return {};
    }
  }
}

class MenuStoragePreferences {
  static late SharedPreferences _preferences;
  static const allTimeMenuKey = "menuList";
  static const mealKey = "meal";

  static Future init() async => 
      _preferences = await SharedPreferences.getInstance();

  static Future setAllTimeMenusPerWeek(Map menuList) async 
  {
    final strAllTimeMenusPerWeek = json.encode(menuList);
    await _preferences.setString(allTimeMenuKey, strAllTimeMenusPerWeek);
  }

  static Map getAllTimeMenusPerWeek()
  {
    final allTimeMenusPerWeek = _preferences.getString(allTimeMenuKey) ?? "";
    if (allTimeMenusPerWeek != "") {
      return json.decode(allTimeMenusPerWeek);
    } else {
      return {};
    }
  }

  static Future addMeal(List<String> meals) async
  {
    await _preferences.setStringList(mealKey, meals);
  }

  static List<String>? getMeals()
  {
    return _preferences.getStringList(mealKey);
  }
}
