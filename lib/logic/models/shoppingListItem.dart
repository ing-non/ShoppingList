class ShoppingListItem {
  final int? id;
  String name;
  String amount;
  bool checked;
  DateTime createdTime;

  ShoppingListItem(
      {this.id,
      required this.name,
      required this.amount,
      required this.checked,
      required this.createdTime});

  Map<String, dynamic> toJson() => {
        "name": name,
        "amount": amount,
        "checked": checked,
        "createdTime": createdTime.toIso8601String(),
      };
}
