class Meal
{
  Meal({this.name, this.ingredients});
  String? name;
  Map? ingredients;

  Map<String, dynamic> toJson() =>{
    "name": name,
    "ingredients": ingredients
  };

  Meal.fromJson(Map json)
      : name = json['name'],
        ingredients = json['ingredients'];
}
