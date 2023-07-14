// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:test_app/globals.dart';
import 'add_list_item.dart';
import 'edit_list_item.dart';

class ShoppingListView extends StatefulWidget {
  String title;
  ShoppingListView(this.title, {super.key});
  @override
  ShoppingListViewState createState() => ShoppingListViewState();
}

class ShoppingListViewState extends State<ShoppingListView> {
  static double addItemSize = 56;
  Map shoppingLists = {};
  Map shoppingList = {};
  List shoppingListItems = [];

  @override
  void initState() {
    super.initState();
    shoppingLists = ShoppingListPreferences.getShoppingLists();
    shoppingList = shoppingLists[widget.title];
    shoppingListItems = shoppingList.values.toList();
  }

  void refresh() {
    setState(() {
      shoppingLists = ShoppingListPreferences.getShoppingLists();
      shoppingList = shoppingLists[widget.title];
      shoppingListItems = shoppingList.values.toList();
    });
  }

  void deleteItem(String key) {
    shoppingList.remove(key);
    shoppingLists[widget.title] = shoppingList;
    ShoppingListPreferences.setShoppingLists(shoppingLists);
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 245, 245, 245),
          title: Text(
            widget.title,
            style: TextStyle(color: Color.fromARGB(230, 65, 65, 65)),
          ),
          iconTheme: IconThemeData(color: Color.fromARGB(230, 65, 65, 65)),
          elevation: 0,
          actions: [
            Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Ink(
                    width: addItemSize,
                    height: addItemSize,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(addItemSize / 2),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddShoppingListItem(
                                widget.title,
                                notifyParent: refresh),
                          ),
                        ).then((value) {
                          setState(() {
                            shoppingLists =
                                ShoppingListPreferences.getShoppingListItem(
                                    widget.title);
                          });
                        });
                      },
                      child: Icon(
                        Icons.add,
                        color: Color.fromARGB(230, 65, 65, 65),
                      ),
                    )))
          ],
        ),
        body: ScrollConfiguration(
          behavior: ScrollBehavior(),
          child: GlowingOverscrollIndicator(
            axisDirection: AxisDirection.down,
            color: Colors.purpleAccent,
            child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: shoppingList.keys.toList().length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      key: Key('$index'),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 5, top: 5),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 245, 245, 245),
                        ),
                        child: Theme(
                          data: ThemeData(
                              unselectedWidgetColor: Colors.purpleAccent),
                          child: CheckboxListTile(
                            contentPadding:
                                EdgeInsets.only(left: 30, right: 20),
                            activeColor: Colors.purpleAccent,
                            title: Text(
                              "${index + 1} ${shoppingList.keys.toList()[index]}",
                              style: TextStyle(
                                  fontWeight: shoppingListItems[index][1]
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  decoration: shoppingListItems[index][1]
                                      ? TextDecoration.lineThrough
                                      : null,
                                  decorationThickness: 4),
                            ),
                            subtitle: Text("${shoppingListItems[index][0]}",
                                style: TextStyle(
                                    decoration: shoppingListItems[index][1]
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationThickness: 4)),
                            value: shoppingListItems[index][1],
                            onChanged: (bool? newValue) {
                              setState(() {
                                shoppingListItems[index][1] = newValue;
                                shoppingList.values.toList()[index][1] =
                                    newValue;
                                shoppingLists[widget.title] = shoppingList;
                                ShoppingListPreferences.setShoppingLists(
                                    shoppingLists);
                              });
                            },
                            secondary: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ReorderableDragStartListener(
                                  index: index,
                                  child: Icon(Icons.drag_handle),
                                ),
                                GestureDetector(
                                    child: Icon(Icons.edit),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditShoppingListItem(
                                                    shoppingList.keys
                                                        .toList()[index]
                                                        .toString(),
                                                    shoppingList.values
                                                        .toList()[index][0],
                                                    widget.title,
                                                    index)),
                                      ).then(
                                        (value) {
                                          refresh();
                                        },
                                      );
                                    })
                              ],
                            ),
                          ),
                        ),
                      ),
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    "Do you want to delete \"${shoppingList.keys.toList()[index]}\""),
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
                                      onPressed: () {
                                        deleteItem(
                                            shoppingList.keys.toList()[index]);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Delete")),
                                ],
                              );
                            });
                      });
                },
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    Map<String, List<dynamic>> newShoppingList = {};
                    List itemKeys = shoppingList.keys.toList();
                    final String item = itemKeys.removeAt(oldIndex);
                    itemKeys.insert(newIndex, item);

                    for (final index in itemKeys) {
                      newShoppingList[index] = shoppingList[index];
                    }

                    shoppingList = newShoppingList;
                    shoppingLists[widget.title] = shoppingList;
                    ShoppingListPreferences.setShoppingLists(shoppingLists);
                    refresh();
                  });
                }),
          ),
        ));
  }
}
