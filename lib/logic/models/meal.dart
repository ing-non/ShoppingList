class Meal
{
  Meal({this.name, this.ingredients});
  String? name;
  Map<String, String>? ingredients;

  Map<String, dynamic> toJson() =>{
    "name": name,
    "ingredients": ingredients
  };
}
