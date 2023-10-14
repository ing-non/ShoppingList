import 'dart:collection';

import '../globals.dart';
import 'models/meal.dart';

class MealListLogic {
  late Map meals;
  MealListLogic() {
    meals = MenuStoragePreferences.getMeals();
  }

  void sortMealsAlphabetically() {
    final SplayTreeMap splayTreeMeals = SplayTreeMap.from(meals);

    print(splayTreeMeals);
  }

  void addMeal(Meal meal) {
    meals[meal.name] = meal.ingredients;
    print(meals);
    MenuStoragePreferences.setMeals(meals);
  }

  void delete(String mealName)
  {
    meals.remove(mealName);
    MenuStoragePreferences.setMeals(meals);
  }
}
