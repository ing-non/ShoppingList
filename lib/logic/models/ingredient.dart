import 'package:sembast/timestamp.dart';

class Ingredient {
  String name;
  String amount;
  DateTime? creationTime;
  Ingredient({required this.name, required this.amount, this.creationTime});

  Map<String, dynamic> toJson() =>
      {"name": name, "amount": amount, "creationTime": creationTime};
}
