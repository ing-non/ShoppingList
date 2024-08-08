import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/logic/models/ingredient.dart';
import '../logic/models/meal.dart';

class MealRepository {
  final mealCollection = FirebaseFirestore.instance.collection("Meals");

  Future<String> addMeal(Meal meal) async {
    var mealRef = await mealCollection.add(meal.toJson());
    return mealRef.id;
  }

  Stream<QuerySnapshot> getMeals() {
    final mealStream = mealCollection.snapshots();
    return mealStream;
  }

  Future<void> editMeal(String mealDocID, String newTitle) {
    return mealCollection.doc(mealDocID).update({"name": newTitle});
  }

  Future<void> deleteMeal(String mealDocID) {
    deleteIngredients(mealDocID);
    return mealCollection.doc(mealDocID).delete();
  }

  Future<void> addIngredient(String mealDocID, Ingredient ingredient) async {
    await mealCollection
        .doc(mealDocID)
        .collection("Ingredients")
        .add(ingredient.toJson());
  }

  Stream<QuerySnapshot> getIngredients(String mealDocID) {
    final ingredientStream =
        mealCollection.doc(mealDocID).collection("Ingredients").snapshots();
    return ingredientStream;
  }

  Future<void> deleteIngredients(String mealDocID) async {
    var ingredients =
        await mealCollection.doc(mealDocID).collection("Ingredients").get();
    for (final ingredient in ingredients.docs) {
      mealCollection
          .doc(mealDocID)
          .collection("Ingredients")
          .doc(ingredient.id)
          .delete();
    }
  }
}
