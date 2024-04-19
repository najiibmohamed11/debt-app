import 'dart:ffi';
import 'dart:math';

import 'package:debt_manager/components/dashlines.dart';
import 'package:debt_manager/components/itemscard.dart';
import 'package:debt_manager/components/totall.dart';
import 'package:debt_manager/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:intl/intl.dart';

enum Options { SOS, $ }

class ItemsPage extends StatefulWidget {
  ItemsPage({
    super.key,
    required this.debetorname,
    required this.index,
  });
  String? debetorname;
  int index;

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

final itemsBox = Hive.box("itemsBox");

class _ItemsPageState extends State<ItemsPage> {
  String? itemname;
  String? itempriceindollar;
  String? itempriceinsos = "";
  double? total_amount_off_dollar = 0.0;
  double? total_amount_off_sos = 0.0;
  Options? _selectedOption = Options.SOS; // Default selection
  DateTime now = DateTime.now();

  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // setState(() {
    //   updateItemInHiveBox(widget.index, total_amount_off_dollar.toString(),
    //       total_amount_off_sos.toString());
    // });
    // homeStateKey.currentState?.updateUI();
    super.dispose();
  }

  void updateItemInHiveBox(
      int key, String newAmountForDollar, String newAmountForSos) {
    var debtorsBox = Hive.box("debtorsBox");
    List<dynamic> currentData =
        debtorsBox.getAt(key); // Retrieve the current data

    // Update specific fields
    if (currentData.length >= 4) {
      currentData[2] = newAmountForDollar; // Update the amount in dollars
      currentData[3] = newAmountForSos; // Update the amount in Somali Shillings
    }

    // Put the updated array back into the box with the same key
    debtorsBox.putAt(key, currentData);
  }

  void addnewitem(String date) {
    int newKey = 1;
    if (itemsBox.isNotEmpty) {
      final lastKey = itemsBox.keys.cast<int>().reduce(max);
      newKey = lastKey + 1;
    }
    itemsBox.put(newKey, [
      widget.debetorname,
      itemname,
      itempriceindollar,
      itempriceinsos,
      date
    ]);
  }

  void delete(
      int key, String itemname, String priceDolar, String priceSos) async {
    final bool? confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text(
              'Are you sure you want to delete $itemname with price of $priceDolar $priceSos?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('No'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await itemsBox.delete(key); // Delete the item from Hive box using the key
      loadItems(); // Reload the items from Hive to update the UI
      setState(() {}); // Update the UI to reflect changes
    }
  }

  void loadItems() {
    items.clear();
    double tempTotalSos = 0.0; // Temporary variable to accumulate SOS total.
    double tempTotalDollar =
        0.0; // Temporary variable to accumulate Dollar total.

    itemsBox.toMap().forEach((key, value) {
      if (value[0] == widget.debetorname) {
        items.add({"key": key, "value": value});

        try {
          double currentItemPriceSos = double.tryParse(value[3]) ?? 0.0;
          double currentItemPriceDollar = double.tryParse(value[2]) ?? 0.0;
          tempTotalSos += currentItemPriceSos; // Accumulate the SOS total.
          tempTotalDollar +=
              currentItemPriceDollar; // Accumulate the Dollar total.
        } catch (e) {
          print('Error parsing string to double: $e');
        }
      }
    });

    setState(() {
      total_amount_off_sos =
          tempTotalSos; // Set the accumulated SOS total after the loop.
      total_amount_off_dollar =
          tempTotalDollar; // Set the accumulated Dollar total after the loop.
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMM').format(now);

    loadItems();

    Future<void> oppendilogbox() => showDialog(
        context: context,
        builder: (context) => Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.90, // Adjust width here
                constraints: BoxConstraints(
                  minHeight: 230.0, // Minimum height
                  maxHeight: MediaQuery.of(context).size.height *
                      0.7, // Maximum height
                ),
                child: StatefulBuilder(
                    builder: (context, setState) => AlertDialog(
                          title: Text("Add New item"),
                          content: ListView(
                            children: [
                              TextField(
                                onChanged: (value) {
                                  setState(() {
                                    itemname = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              _selectedOption == Options.$
                                  ? TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          itempriceinsos = " ";
                                          itempriceindollar = value;
                                        });
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "price in dollar \$\$\$",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(
                                height: 20.0,
                              ),
                              _selectedOption == Options.SOS
                                  ? TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          itempriceindollar = "";

                                          itempriceinsos = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: "price in shiling somali sos",
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("SOS"),
                                  Radio<Options>(
                                    value: Options.SOS,
                                    groupValue: _selectedOption,
                                    onChanged: (Options? value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                  ),
                                  Text("\$"),
                                  Radio<Options>(
                                    value: Options.$,
                                    groupValue: _selectedOption,
                                    onChanged: (Options? value) {
                                      setState(() {
                                        _selectedOption = value;
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                          actions: [
                            MaterialButton(
                              onPressed: () {
                                this.setState(() {
                                  updateItemInHiveBox(
                                      widget.index,
                                      total_amount_off_dollar.toString(),
                                      total_amount_off_sos.toString());
                                  addnewitem(formattedDate);
                                });

                                Navigator.pop(context);
                              },
                              child: Text(
                                "Add",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.green,
                            )
                          ],
                        )),
              ),
            ));

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            oppendilogbox();
          }),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(25.0))),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            updateItemInHiveBox(
                                widget.index,
                                total_amount_off_dollar.toString(),
                                total_amount_off_sos.toString());
                          });
                          homeStateKey.currentState?.updateUI();

                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      AutoSizeText(
                        widget.debetorname!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18.0),
                        maxLines: 1, // Ensures the text does not wrap
                        minFontSize:
                            10, // Set the minimum font size you want to allow
                        overflow: TextOverflow
                            .ellipsis, // Adds an ellipsis at the end if the text is still too long
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Text(
                        "items",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w300),
                      ),
                      Spacer(),
                      Text(
                        items.length.toString(),
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  DashedLine(
                    color: Colors.grey,
                  ),
                  Total(
                    text: "total dollar",
                    total: "\$$total_amount_off_dollar",
                  ),
                  Total(
                    text: "total shiling somali",
                    total: "$total_amount_off_sos",
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 100.0, top: 30.0, left: 10.0),
              child: Row(
                children: [
                  SizedBox(width: 12),
                  Expanded(
                    // This will allow the first text to expand
                    flex: 1, // You can adjust flex to control space allocation
                    child: Text(
                      "Item Name",
                      overflow: TextOverflow
                          .ellipsis, // Prevents text from breaking layout
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                    // This will keep this space even if there's no text
                    flex: 1,
                    child: Text(
                      "dollar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                    // This will allow the number text to expand
                    flex: 1,
                    child: Text(
                      "sos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Expanded(
                    // This will allow the number text to expand
                    flex: 1,
                    child: Text(
                      "date",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            DashedLine(
              color: Colors.grey,
            ),
            items.isEmpty
                ? SizedBox.shrink()
                : Expanded(
                    child: ListView.builder(
                        itemCount: items.length,
                        // In your ListView.builder
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ItemsCard(
                            itemname: item["value"][1],
                            priceindollar: item["value"][2],
                            priceinsos: item["value"][3],
                            date: item["value"][4],
                            onPressed: () {
                              delete(
                                  item["key"],
                                  item["value"][1],
                                  item["value"][2] == ""
                                      ? ""
                                      : '\$${item["value"][2]}',
                                  item["value"][3] == " "
                                      ? ""
                                      : '${item["value"][3]}K shilling somali'); // Use the actual key
                            },
                          );
                        }))
          ],
        ),
      ),
    );
  }
}
