final String tableShoppingLists = "shoppingList";

class ShoppingList {
  final int? id;
  final String name;
  final DateTime createdTime;
  final int order;
  const ShoppingList({this.id, required this.name, required this.order, required this.createdTime});

  Map<String, dynamic> toJson() => {
        "name": name,
        "createdTime": createdTime.toIso8601String(),
        "order": order
      };
}