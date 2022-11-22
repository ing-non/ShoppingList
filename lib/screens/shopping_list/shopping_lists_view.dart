// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'add_list.dart';
import 'shopping_list_view.dart';
import 'edit_list.dart';

String shoppingListsName = "Shopping Lists";


class ShoppingListHome extends StatefulWidget {
  Map<String, Map<String, List>> shoppingLists = {};
  ShoppingListHome(this.shoppingLists, {super.key});

  @override
  State<ShoppingListHome> createState() => _ShoppingListHomeState();
}

class _ShoppingListHomeState extends State<ShoppingListHome> {
  @override
  void _deleteList(String key) {
    widget.shoppingLists.remove(key);
    setState(() {});
  }

  static double addListSize = 56;

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
                                    builder: (context) =>
                                        AddShoppingList(widget.shoppingLists)))
                            .then((value) {
                          setState(() {});
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
                for (final list in widget.shoppingLists.keys)
                  HomeScreenCard(
                    key: ValueKey(list),
                    list,
                    widget.shoppingLists[list]!,
                    widget.shoppingLists,
                    deleteList: _deleteList,
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  Map<String, Map<String, List<dynamic>>> newShoppingLists = {};
                  List itemKeys = widget.shoppingLists.keys.toList();
                  final String item = itemKeys.removeAt(oldIndex);
                  itemKeys.insert(newIndex, item);

                  for (final index in itemKeys) {
                    newShoppingLists[index] = widget.shoppingLists[index]!;
                  }

                  widget.shoppingLists = newShoppingLists;
                });
              }),
        ),
      ),
    );
  }
}

class HomeScreenCard extends StatefulWidget {
  final title;
  final Map<String, List<dynamic>> shoppingList;
  Map<String, Map<String, List<dynamic>>> shoppingLists;

  final deleteList;

  HomeScreenCard(this.title, this.shoppingList, this.shoppingLists,
      {super.key, this.deleteList});

  @override
  State<HomeScreenCard> createState() => _HomeScreenCardState();
}

class _HomeScreenCardState extends State<HomeScreenCard> {
  static double subTextSize = 15;
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
            if (widget.shoppingList.length >= 3) ...[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.shoppingList.keys.toList()[0].toString()} : ${widget.shoppingList.values.toList()[0][0].toString()}",
                        style: TextStyle(fontSize: subTextSize),
                      ),
                      Text(
                        "${widget.shoppingList.keys.toList()[1].toString()} : ${widget.shoppingList.values.toList()[1][0].toString()}",
                        style: TextStyle(fontSize: subTextSize),
                      ),
                      Text(
                        "${widget.shoppingList.keys.toList()[2].toString()} : ${widget.shoppingList.values.toList()[2][0].toString()}",
                        style: TextStyle(fontSize: subTextSize),
                      ),
                    ],
                  ))
            ] else ...[
              for (final list in widget.shoppingList.keys)
                Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${list} : ${widget.shoppingList.values.toList()[0][0].toString()}"),
                        ])),
            ],
            Spacer(flex: 1),
            Row(
              children: [
                GestureDetector(
                  child: Icon(Icons.edit),
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditShoppingListItem(
                                    widget.title, widget.shoppingLists)))
                        .then((value) {
                      setState() {}
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
                                    primary: Colors.red),
                                onPressed: () {
                                  Navigator.pop(context);
                                  widget.deleteList(widget.title);
                                },
                                child: Text("Delete?")),
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
                  ShoppingListView(widget.shoppingList, widget.title),
            ),
          );
        });
  }
}



