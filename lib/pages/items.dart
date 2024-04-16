import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ItemsPage extends StatefulWidget {
  ItemsPage({super.key, required this.debetorname});
  String? debetorname;

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

enum Options { SOS, $ }

final itemsBox = Hive.box("itemsBox");

class _ItemsPageState extends State<ItemsPage> {
  String? itemname;
  String? itempriceindollar;
  String? itempriceinsos = "";
  String? _selectedOption = "sos";

  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
  }

  void addnewitem() {
    int newKey = 1;
    if (itemsBox.isNotEmpty) {
      final lastKey = itemsBox.keys.cast<int>().reduce(max);
      newKey = lastKey + 1;
    }
    itemsBox.put(newKey, [
      widget.debetorname,
      itemname,
      itempriceindollar ?? "\$",
      itempriceinsos ?? "sos",
    ]);
  }

  void delete(int index) {
    setState(() {
      itemsBox.deleteAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    items.clear();
    itemsBox.toMap().forEach((key, value) {

      if (value[0] == widget.debetorname) {
        items.add({"key": key, "value": value});
      }

      // You can process the value further here
    });

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
                child: AlertDialog(
                  title: Text("Add New item"),
                  content: ListView(
                    children: [
                      TextField(
                        onChanged: (value) {
                          print("Changing value to: $value");

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
                      TextField(
                        onChanged: (value) {
                          print("Changing value to: $value");
                          setState(() {
                            itempriceinsos = " ";
                            itempriceindollar = value;
                          });
                        },
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "price in dollar \$\$\$",
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        keyboardType: TextInputType.phone,
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
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {});
                        addnewitem();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Add",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green,
                    )
                  ],
                ),
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
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      SizedBox(
                        width: 120.0,
                      ),
                      Text(
                        widget.debetorname!,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      )
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
                            fontSize: 15.0, fontWeight: FontWeight.w300),
                      ),
                      Spacer(),
                      Text(
                        "5",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  DashedLine(
                    color: Colors.grey,
                  ),
                  Total(),
                  Total(),
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
                    itemBuilder: (context, index) => Items(
                      itemname: items[index]["value"][1],
                      priceindollar: items[index]["value"][2],
                      priceinsos: items[index]["value"][3],
                      onPressed: () => delete(index),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}

class Items extends StatelessWidget {
  Items({
    super.key,
    required this.itemname,
    required this.priceindollar,
    required this.priceinsos,
    required this.onPressed,
  });
  final String itemname;
  final String priceindollar;
  final String priceinsos;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .spaceBetween, // Aligns children across the main axis
        children: [
          Expanded(
            flex: 2,
            child: Text(
              itemname,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              priceindollar,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              priceinsos,
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
            ),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(Icons.cancel_rounded, color: Colors.red),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

class Total extends StatelessWidget {
  const Total({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "total dollar",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
        Spacer(),
        Text(
          "\$10",
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}

class DashedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const DashedLine({
    Key? key,
    this.height = 1,
    this.color = Colors.grey,
    this.dashWidth = 10,
    this.dashSpace = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount =
            (constraints.maxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List<Widget>.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: height,
              color: color,
            );
          }),
        );
      },
    );
  }
}
