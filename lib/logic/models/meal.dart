import 'package:sembast/timestamp.dart';

class Meal {
  String name;
  DateTime? creationTime;
  Meal(this.name, this.creationTime);

  Map<String, dynamic> toJson() => {
        "name": name,
        "creationTime": creationTime
      };
}
