import 'dart:ffi';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

String? nameofthedebter;

final debtorsBox = Hive.box("debtorsBox");
void addNewDebtor(String newDebtor) {
  // Get the current highest key in the box
  int newKey = 1;
  if (debtorsBox.isNotEmpty) {
    final lastKey = debtorsBox.keys.cast<int>().reduce(max);
    newKey = lastKey + 1;
  }

  // Put the new debtor in the box with an auto-incremented key
  debtorsBox.put(newKey, newDebtor);
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    String? selectedCategory = "famale";
    final List<String> categories = ['male', 'famale']; // Examp
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
                          selectedCategory = newValue;
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
                        addNewDebtor(nameofthedebter!);
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
      floatingActionButton: FloatingActionButton(onPressed: () {
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
                    total_price: 45.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Total_card(
                    imagepth: 'images/dollar.png',
                    titile: "total dollar",
                    total_price: 45.0,
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
              // debtorsBox.isEmpty
              //     ? Text("no one is in you'r debtors")
              //     :
              Expanded(
                child: ListView.separated(
                  itemCount: debtorsBox.length,
                  itemBuilder: (context, index) {
                    return DebtorsCard(
                      Total_dollor: 12.0,
                      Total_shiling_somali: 20,
                      imagepath: selectedCategory == 'famale'
                          ? "images/hijabgirl.png"
                          : "images/black man.png",
                      titile: debtorsBox.getAt(index),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Divider(), // Adds a divider between each item
                ),
              ),

              Divider()
            ],
          ),
        ),
      ),
    );
  }
}

class DebtorsCard extends StatelessWidget {
  DebtorsCard({
    required this.imagepath,
    required this.titile,
    // required this.mounth,
    required this.Total_dollor,
    required this.Total_shiling_somali,
  });
  String? imagepath;
  String? titile;
  // String? mounth;
  double? Total_dollor;
  int? Total_shiling_somali;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 70,
        height: 90,
        decoration: BoxDecoration(
            color: Color(0xffF1EBE2),
            borderRadius: BorderRadius.circular(12.0)),
        child: Image.asset(imagepath!),
      ),
      title: Text(
        titile!,
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      // subtitle: Text(mounth!),
      trailing: Column(
        children: [
          Text(
            "\$${Total_dollor}",
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            "$Total_shiling_somali k",
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}

class Total_card extends StatelessWidget {
  Total_card(
      {super.key,
      required this.titile,
      required this.imagepth,
      required this.total_price});

  final String imagepth;
  final String titile;
  final double total_price;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Flexible(
      child: Container(
          width: screenWidth * 0.45, // Dynamically size based on screen width
          height: 100.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.black,
              )),
          child: Row(
            children: [
              Image.asset(
                imagepth,
                width: 50,
                height: 50.0,
              ),
              Expanded(
                // Ensure the text does not overflow
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titile,
                      style: TextStyle(letterSpacing: 0.5, fontSize: 15.0),
                    ),
                    Text(
                      '\$${total_price.toString()}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
