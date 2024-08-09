import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/logic/models/menu.dart';

class MenuRepository {
  final menuCollection = FirebaseFirestore.instance.collection("Menus");

  Future<void> addMenu(Menu menu) async {
    await menuCollection.add(menu.toJson());
  }

  Stream<QuerySnapshot> getMenus() {
    final menuStream = menuCollection.orderBy("startDate").snapshots();
    return menuStream;
  }

  Future<QuerySnapshot> getAllMenus() {
    return menuCollection.orderBy("startDate", descending: true).get();
  }

  Future<void> deleteMenu(menuDocID)
  {
    return menuCollection.doc(menuDocID).delete();
  }
}
