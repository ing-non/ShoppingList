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

  static Map getShoppingLists()
  {
    final shoppingLists = _preferences.getString(shoppingListKey) ?? "";
    if (shoppingLists != "")
    {
      return json.decode(shoppingLists);
    }
    else
    {
      return {};
    }
  }

  static Future setShoppingListItem(Map shoppingListItem, String key) async {
    final strShoppingListItem = json.encode(shoppingListItem);
    await _preferences.setString(key, strShoppingListItem);
  }

  static Map getShoppingListItem(String key)
  {
    final shoppingListItem = _preferences.getString(key) ?? "{}";
    return json.decode(shoppingListItem);
  }

  static void removeByKey(String key)
  {
    _preferences.remove(key);
  }

}