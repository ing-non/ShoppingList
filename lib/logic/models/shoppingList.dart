import 'shoppingListItem.dart';

class ShoppingList
{
  ShoppingList({this.name, this.items});

  String? name;
  List<ShoppingListItem>? items;

  Map<String, dynamic> toJson() => {
    "name" : name,
    "shoppingListItems" : items
  };
  
}