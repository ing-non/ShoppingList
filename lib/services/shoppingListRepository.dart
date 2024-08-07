import 'package:cloud_firestore/cloud_firestore.dart';

import '../logic/models/shoppingList.dart';
import '../logic/models/shoppingListItem.dart';

class ShoppingListRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> createShoppingList(ShoppingList shoppingList) async {
    await _db.collection("ShoppingLists").add(shoppingList.toJson());
  }

  Stream<QuerySnapshot> getShoppingLists() {
    final shoppingListsStream =
        _db.collection("ShoppingLists").orderBy('order').snapshots();
    return shoppingListsStream;
  }

  Future<void> editShoppingList(String listDocID, String newTitle) {
    return _db
        .collection("ShoppingLists")
        .doc(listDocID)
        .update({'name': newTitle, 'createdTime': DateTime.now()});
  }

  Stream<QuerySnapshot> getShoppingListById(String listDocID) {
    final shoppingListStream = _db
        .collection("ShoppingLists")
        .doc(listDocID)
        .collection("ShoppingListItems")
        .snapshots();
    return shoppingListStream;
  }

  Future<void> deleteShoppingList(String listDocID) {
    return _db.collection("ShoppingLists").doc(listDocID).delete();
  }

  Future<void> createShoppingListItem(
      String listDocID, ShoppingListItem shoppingListItem) async {
    await _db
        .collection("ShoppingLists")
        .doc(listDocID)
        .collection("ShoppingListItems")
        .add(shoppingListItem.toJson());
  }

  Future<void> editShoppingListItem(
      String listDocID, String itemDocID, String? newTitle, String? newAmount) {
    return _db
        .collection("ShoppingLists")
        .doc(listDocID)
        .collection("ShoppingListItems")
        .doc(itemDocID)
        .update({
      'name': newTitle,
      'amount': newAmount,
      'createdTime': DateTime.now()
    });
  }

  Future<void> updateShoppingListItemChecked(
      String listDocID, String itemDocID, bool? checked) {
    return _db
        .collection("ShoppingLists")
        .doc(listDocID)
        .collection("ShoppingListItems")
        .doc(itemDocID)
        .update({'checked': checked});
  }

  Future<void> deleteShoppingListItem(String listDocID, String itemDocID) {
    return _db
        .collection("ShoppingLists")
        .doc(listDocID)
        .collection("ShoppingListItems")
        .doc(itemDocID)
        .delete();
  }

  WriteBatch getBatch() {
    return _db.batch();
  }
}