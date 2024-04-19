import 'dart:ffi';
import 'dart:math';

import 'package:debt_manager/components/debtorcard.dart';
import 'package:debt_manager/components/totalcard.dart';
import 'package:debt_manager/pages/items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:auto_size_text/auto_size_text.dart';

GlobalKey<_HomeState> homeStateKey = GlobalKey();

class Home extends StatefulWidget {
  const Home({Key? key})
      : super(key: key); // Ensure key is handled properly here

  @override
  State<Home> createState() => _HomeState();
}

String? nameofthedebter;
String? pnone;
String selectedCategory = "female";
double? total_amount_off_dollar = 0.0;
double? total_amount_off_sos = 0.0;

final debtorsBox = Hive.box("debtorsBox");

Future<void> addNewDebtor(String newDebtor, String selectedCategory) async {
  var debtorsBox = Hive.box("debtorsBox");
  final itemsBox = Hive.box("itemsBox");

  int newKey =
      debtorsBox.isNotEmpty ? debtorsBox.keys.cast<int>().reduce(max) + 1 : 1;
  await debtorsBox.put(newKey, [newDebtor, selectedCategory, "0.0", "0.0"]);
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void totalamounts() {
    double tempTotalSos = 0.0; // Temporary variable to accumulate SOS total.
    double tempTotalDollar =
        0.0; // Temporary variable to accumulate Dollar total.

    itemsBox.toMap().forEach((key, value) {
      try {
        double currentItemPriceSos = double.tryParse(value[3]) ?? 0.0;
        double currentItemPriceDollar = double.tryParse(value[2]) ?? 0.0;
        tempTotalSos += currentItemPriceSos; // Accumulate the SOS total.
        tempTotalDollar +=
            currentItemPriceDollar; // Accumulate the Dollar total.
      } catch (e) {
        print('Error parsing string to double: $e');
      }
    });
    setState(() {
      total_amount_off_sos = tempTotalSos;
      total_amount_off_dollar = tempTotalDollar;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void updateUI() {
    setState(() {
      // This will force a rebuild of the Home widget
    });
  }

  @override
  Widget build(BuildContext context) {
    totalamounts();
    final List<String> categories = ['male', 'female']; // Examp

    Future<void> opendilogbox() => showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              width:
                  MediaQuery.of(context).size.width * 0.9, // Adjust width here
              constraints: BoxConstraints(
                minHeight: 200.0, // Minimum height
                maxHeight:
                    MediaQuery.of(context).size.height * 0.5, // Maximum height
              ),
              child: AlertDialog(
                title: Text("Add New Debt"),
                content: Column(
                  mainAxisSize:
                      MainAxisSize.min, // Adjust column height to fit contents
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          nameofthedebter = value;
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
                        setState(() {
                          pnone = value;
                        });
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "phone number",
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      setState(() {
                        addNewDebtor(nameofthedebter!, selectedCategory);
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
              ),
            ),
          ),
        );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            opendilogbox();
          }),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "HI Welcome👋",
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  Spacer(),
                  CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text("T"),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Total_card(
                    imagepth: 'images/dollar.png',
                    titile: "total dollar",
                    total_price: "\$$total_amount_off_dollar",
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Total_card(
                    imagepth: 'images/sso.png',
                    titile: "total shilling somali",
                    total_price: "$total_amount_off_sos",
                  ),
                ],
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search..",
                    suffixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Text(
                "debtors",
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              SizedBox(
                height: 25.0,
              ),
              debtorsBox.isEmpty
                  ? Text("no one is in you'r debtors")
                  : Expanded(
                      child: ListView.separated(
                        itemCount: debtorsBox.length,
                        itemBuilder: (context, index) {
                          final debtorData = debtorsBox.getAt(index)
                              as List<dynamic>?; // Cast to avoid type issues
                          if (debtorData == null || debtorData.length < 4) {
                            return SizedBox.shrink(); // or some error widget
                          }
                          String nameOfDebtor = debtorData[0] as String;
                          String category = debtorData[1] as String;
                          String totalDollar = debtorData[2] as String;
                          String totalSomaliShilling = debtorData[3] as String;

                          return DebtorsCard(
                            imagepath: category == 'female'
                                ? "images/hijabgirl.png"
                                : "images/black man.png",
                            titile: nameOfDebtor,
                            Total_dollor: totalDollar,
                            Total_shiling_somali: totalSomaliShilling,
                            index: index,
                            phoneNumber: pnone ?? "61....",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ItemsPage(
                                          debetorname: nameOfDebtor,
                                          index: index,
                                        )),
                              );
                            },
                          );
                        },
                        separatorBuilder: (context, index) =>
                            Divider(), // Adds a divider between each item
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
