import 'package:test_app/logic/models/meal.dart';

class Menu {
  DateTime startDate;
  DateTime endDate;
  List<String> mealIDs;

  Menu(this.mealIDs, {required this.startDate, required this.endDate});

  Map<String, dynamic> toJson() =>
      {"startDate": startDate, "endDate": endDate, "mealIDs": mealIDs};
}
