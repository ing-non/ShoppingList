// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_app/services/shoppingListRepository.dart';
import 'add_list_item.dart';
import 'edit_list_item.dart';

class ShoppingListView extends StatefulWidget {
  String listDocID;
  String title;
  ShoppingListView(this.listDocID, this.title, {super.key});
  @override
  ShoppingListViewState createState() => ShoppingListViewState();
}

class ShoppingListViewState extends State<ShoppingListView> {
  ShoppingListRepository shoppingListRepository = ShoppingListRepository();
  static double addItemSize = 56;

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
                            builder: (context) =>
                                AddShoppingListItem(widget.listDocID),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.add,
                        color: Color.fromARGB(230, 65, 65, 65),
                      ),
                    )))
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream:
                shoppingListRepository.getShoppingListById(widget.listDocID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List shoppingListItemsList = snapshot.data!.docs;
                return ScrollConfiguration(
                  behavior: ScrollBehavior(),
                  child: GlowingOverscrollIndicator(
                    axisDirection: AxisDirection.down,
                    color: Colors.purpleAccent,
                    child: ReorderableListView.builder(
                        buildDefaultDragHandles: false,
                        itemCount: shoppingListItemsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document =
                              shoppingListItemsList[index];
                          String itemDocID = document.id;
                          // get note from each doc
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          String shoppingListItemText = data["name"];
                          return GestureDetector(
                              key: Key('$index'),
                              child: Container(
                                  padding: EdgeInsets.only(bottom: 5, top: 5),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 245, 245, 245),
                                  ),
                                  child: Theme(
                                      data: ThemeData(
                                          unselectedWidgetColor:
                                              Colors.purpleAccent),
                                      child: CheckboxListTile(
                                          contentPadding: EdgeInsets.only(
                                              left: 30, right: 20),
                                          activeColor: Colors.purpleAccent,
                                          title: Text(
                                            "${index + 1} $shoppingListItemText",
                                            style: TextStyle(
                                                fontWeight: data["checked"]
                                                    ? FontWeight.normal
                                                    : FontWeight.bold,
                                                decoration: data["checked"]
                                                    ? TextDecoration.lineThrough
                                                    : null,
                                                decorationThickness: 4),
                                          ),
                                          subtitle: Text("${data["amount"]}",
                                              style: TextStyle(
                                                  decoration: data["checked"]
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : null,
                                                  decorationThickness: 4)),
                                          value: data["checked"],
                                          onChanged: (bool? newValue) {
                                            shoppingListRepository
                                                .updateShoppingListItemChecked(
                                                    widget.listDocID,
                                                    itemDocID,
                                                    newValue);
                                          },
                                          secondary: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ReorderableDragStartListener(
                                                  index: index,
                                                  child:
                                                      Icon(Icons.drag_handle),
                                                ),
                                                GestureDetector(
                                                    child: Icon(Icons.edit),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                EditShoppingListItem(
                                                                    widget
                                                                        .listDocID,
                                                                    itemDocID,
                                                                    shoppingListItemText,
                                                                    data[
                                                                        "amount"])),
                                                      );
                                                    })
                                              ])))),
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Do you want to delete \"$shoppingListItemText\""),
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "Cancel",
                                                  style:
                                                      TextStyle(fontSize: 15),
                                                )),
                                          ),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              onPressed: () {
                                                shoppingListRepository
                                                    .deleteShoppingListItem(
                                                        widget.listDocID,
                                                        itemDocID);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Delete")),
                                        ],
                                      );
                                    });
                              });
                        },
                        onReorder: (int oldIndex, int newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final shoppingList =
                              shoppingListItemsList.removeAt(oldIndex);
                          shoppingListItemsList.insert(newIndex, shoppingList);

                          WriteBatch batch = shoppingListRepository.getBatch();
                          for (int i = 0;
                              i < shoppingListItemsList.length;
                              i++) {
                            batch.update(shoppingListItemsList[i].reference,
                                {'order': i});
                          }
                          batch.commit();
                        }),
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}
