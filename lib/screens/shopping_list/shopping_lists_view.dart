// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:test_app/services/shoppingListRepository.dart';
import 'add_list.dart';
import 'shopping_list_view.dart';
import 'edit_list.dart';

String shoppingListsName = "Shopping Lists";

class ShoppingListHome extends StatefulWidget {
  const ShoppingListHome({super.key});

  @override
  State<ShoppingListHome> createState() => _ShoppingListHomeState();
}

class _ShoppingListHomeState extends State<ShoppingListHome> {
  static double addListSize = 56;
  Map<String, dynamic> shoppingLists = {};
  ShoppingListRepository shoppingListRepository = ShoppingListRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          title: Text(
            shoppingListsName,
            style: TextStyle(color: Color.fromARGB(230, 65, 65, 65)),
          ),
          elevation: 0,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Ink(
                    width: addListSize,
                    height: addListSize,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(addListSize / 2),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddShoppingList()),
                        ).then((value) {
                          setState(() {
                            //shoppingLists =
                            //  shoppingListRepository.getShoppingLists();
                          });
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: Color.fromARGB(230, 65, 65, 65),
                      ),
                    )))
          ]),
      body: StreamBuilder<QuerySnapshot>(
          stream: shoppingListRepository.getShoppingLists(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List shoppingListsList = snapshot.data!.docs;

              return ScrollConfiguration(
                behavior: ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: Colors.purpleAccent,
                  child: ReorderableGridView.builder(
                      itemCount: shoppingListsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: (150 / 200)),
                      physics: ScrollPhysics(),
                      padding: EdgeInsets.all(20),
                      itemBuilder: (context, index) {
                        // get each individual doc
                        DocumentSnapshot document = shoppingListsList[index];
                        String listDocID = document.id;
                        // get note from each doc
                        Map<String, dynamic> data =
                            document.data() as Map<String, dynamic>;
                        String shoppingListText = data["name"];

                        // display as a grid tile
                        return HomeScreenCard(listDocID, shoppingListText,
                            key: ValueKey(shoppingListText));
                      },
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final shoppingList =
                            shoppingListsList.removeAt(oldIndex);
                        shoppingListsList.insert(newIndex, shoppingList);

                        WriteBatch batch = shoppingListRepository.getBatch();
                        for (int i = 0; i < shoppingListsList.length; i++) {
                          batch.update(
                              shoppingListsList[i].reference, {'order': i});
                        }
                        batch.commit();
                      }),
                ),
              );
            } else {
              return Scaffold();
            }
          }),
    );
  }
}

class HomeScreenCard extends StatefulWidget {
  String listDocID;
  String title;

  HomeScreenCard(
    this.listDocID,
    this.title, {
    super.key,
  });

  @override
  State<HomeScreenCard> createState() => _HomeScreenCardState();
}

class _HomeScreenCardState extends State<HomeScreenCard> {
  final double subTextSize = 16;
  ShoppingListRepository shoppingListRepository = ShoppingListRepository();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: EdgeInsets.all(10),
          height: 200,
          width: 150,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 235, 235, 235),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 2),
                )
              ]),
          child: Column(children: [
            Text(widget.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: shoppingListRepository
                      .getShoppingListById(widget.listDocID),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List shoppingListItemsList = snapshot.data!.docs;
                      final itemCount = min(shoppingListItemsList.length, 5);
                      return ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document =
                              shoppingListItemsList[index];
                          String itemDocID = document.id;
                          // get note from each doc
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          String shoppingListItemText = data["name"];
                          return Text(
                            "$shoppingListItemText : ${data["amount"]}",
                            style: TextStyle(fontSize: subTextSize),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  }),
            ),
            Row(
              children: [
                GestureDetector(
                  child: Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditShoppingList(
                                widget.listDocID, widget.title)));
                  },
                ),
                Spacer(flex: 1),
                GestureDetector(
                  child: Icon(Icons.delete),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title:
                              Text("Do you want to delete \"${widget.title}\""),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 15),
                                  )),
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () async {
                                  shoppingListRepository
                                      .deleteShoppingList(widget.listDocID);
                                  Navigator.pop(context);
                                },
                                child: Text("Delete")),
                          ],
                        );
                      },
                    );
                  },
                )
              ],
            )
          ]),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ShoppingListView(widget.listDocID, widget.title),
            ),
          );
        });
  }
}
