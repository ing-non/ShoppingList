final String tableShoppingLists = "shoppingList";

class ShoppingList {
  String name;
  DateTime creationTime;
  int order;
  ShoppingList(this.name,  this.order,  this.creationTime);

  Map<String, dynamic> toJson() => {
        "name": name,
        "creationTime": creationTime.toIso8601String(),
        "order": order
      };
}