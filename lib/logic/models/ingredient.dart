import 'package:sembast/timestamp.dart';

class Ingredient{
  String name;
  DateTime creationTime;
  Ingredient(this.name, this.creationTime);

  Map<String, dynamic> toJson() => {
        "name": name,
        "creationTime": creationTime
      };
}