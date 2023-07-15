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
