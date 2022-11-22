// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'add_list_item.dart';
import 'edit_list_item.dart';

class ShoppingListView extends StatefulWidget {
  Map<String, List> listData = {};
  String title;
  ShoppingListView(this.listData, this.title, {super.key});
  @override
  ShoppingListViewState createState() => ShoppingListViewState();
}

class ShoppingListViewState extends State<ShoppingListView> {
  static double addItemSize = 56;


  @override
  void delete_item(String key) {
    widget.listData.remove(key);
    setState(() {});
  }

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
                            builder: (context) =>
                                AddShoppingListItem(widget.listData),
                          ),
                        ).then((value) {
                          setState(() {});
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
                itemCount: widget.listData.keys.toList().length,
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
                              "${index + 1} ${widget.listData.keys.toList()[index]}",
                              style: TextStyle(
                                  fontWeight:
                                      widget.listData.values.toList()[index][1]
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                  decoration:
                                      widget.listData.values.toList()[index][1]
                                          ? TextDecoration.lineThrough
                                          : null,
                                  decorationThickness: 4),
                            ),
                            subtitle: Text(
                                widget.listData.values.toList()[index][0],
                                style: TextStyle(
                                    decoration: widget.listData.values
                                            .toList()[index][1]
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationThickness: 4)),
                            value: widget.listData.values.toList()[index][1],
                            onChanged: (bool? newValue) {
                              setState(() {
                                widget.listData.values.toList()[index][1] =
                                    newValue;
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
                                                  widget.listData.keys
                                                      .toList()[index]
                                                      .toString(),
                                                  widget.listData.values
                                                      .toList()[index][0],
                                                  widget.listData,
                                                  index),
                                        ),
                                      ).then(
                                        (value) {
                                          setState(() {});
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
                                    "Do you want to delete \"${widget.listData.keys.toList()[0]}\""),
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
                                        delete_item(
                                            widget.listData.keys.toList()[0]);
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      child: Text("Delete?")),
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
                    Map<String, List<dynamic>> newListData = {};
                    List itemKeys = widget.listData.keys.toList();
                    final String item = itemKeys.removeAt(oldIndex);
                    itemKeys.insert(newIndex, item);

                    for (final index in itemKeys) {
                      newListData[index] = widget.listData[index]!;
                    }

                    widget.listData = newListData;
                  });
                }),
          ),
        ));
  }
}
