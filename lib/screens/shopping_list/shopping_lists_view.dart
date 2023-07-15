// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:test_app/globals.dart';
import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
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
  Map shoppingLists = {};

  @override
  void initState() {
    super.initState();
    shoppingLists = ShoppingListPreferences.getShoppingLists();
  }

  void _deleteList(String key) {
    shoppingLists = ShoppingListPreferences.getShoppingLists();
    shoppingLists.remove(key);
    ShoppingListPreferences.setShoppingLists(shoppingLists);
  }

  void refresh() {
    setState(() {
      shoppingLists = ShoppingListPreferences.getShoppingLists();
    });
  }

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
                              builder: (context) => AddShoppingList(refresh)),
                        ).then((value) {
                          setState(() {
                            shoppingLists =
                                ShoppingListPreferences.getShoppingLists();
                          });
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: Color.fromARGB(230, 65, 65, 65),
                      ),
                    )))
          ]),
      body: ScrollConfiguration(
        behavior: ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: Colors.purpleAccent,
          child: ReorderableGridView.count(
              physics: ScrollPhysics(),
              crossAxisCount: 2,
              padding: EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: (150 / 200),
              children: [
                for (final listTitle in shoppingLists.keys)
                  HomeScreenCard(
                    listTitle,
                    key: ValueKey(listTitle),
                    deleteList: _deleteList,
                    notifyParent: refresh,
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  Map newShoppingLists = {};
                  List itemKeys = shoppingLists.keys.toList();
                  final String item = itemKeys.removeAt(oldIndex);
                  itemKeys.insert(newIndex, item);

                  for (final index in itemKeys) {
                    newShoppingLists[index] = shoppingLists[index]!;
                  }
                  shoppingLists = newShoppingLists;
                  ShoppingListPreferences.setShoppingLists(shoppingLists);
                });
              }),
        ),
      ),
    );
  }
}

class HomeScreenCard extends StatefulWidget {
  String title;
  final Function deleteList;
  final Function notifyParent;

  HomeScreenCard(this.title,
      {super.key, required this.deleteList, required this.notifyParent});

  @override
  State<HomeScreenCard> createState() => _HomeScreenCardState();
}

class _HomeScreenCardState extends State<HomeScreenCard> {
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
            Spacer(flex: 1),
            Row(
              children: [
                GestureDetector(
                  child: Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditShoppingList(onTitleChanged: (newTitle) {
                                  setState(() {
                                    widget.title = newTitle;
                                  });
                                }, widget.title))).then((value) {

                      widget.notifyParent;
                    });
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
                                  widget.deleteList(widget.title);
                                  setState(() {
                                    widget.notifyParent();
                                  });
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
              builder: (context) => ShoppingListView(widget.title),
            ),
          );
        });
  }
}
