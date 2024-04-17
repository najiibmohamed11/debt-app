import 'dart:ffi';
import 'dart:math';

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
        print(itemsBox.length);
      } catch (e) {
        print('Error parsing string to double: $e');
      }
    });
    setState(() {
      total_amount_off_sos = tempTotalSos;
      total_amount_off_dollar = tempTotalDollar;
    });
    print(tempTotalSos);
    print(tempTotalDollar);
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

class DebtorsCard extends StatelessWidget {
  DebtorsCard({
    required this.imagepath,
    required this.titile,
    // required this.mounth,
    required this.Total_dollor,
    required this.Total_shiling_somali,
    required this.onTap,
  });
  String? imagepath;
  String? titile;
  // String? mounth;
  String? Total_dollor;
  String? Total_shiling_somali;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 70,
        height: 90,
        decoration: BoxDecoration(
            color: Color(0xffF1EBE2),
            borderRadius: BorderRadius.circular(12.0)),
        child: Image.asset(imagepath!),
      ),
      title: AutoSizeText(
        titile!,
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        maxLines: 1, // Ensures the text does not wrap
        minFontSize: 10, // Set the minimum font size you want to allow
        overflow: TextOverflow
            .ellipsis, // Adds an ellipsis at the end if the text is still too long
      ),
      subtitle: Text("0612544158"),
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
  final String total_price;

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
                    AutoSizeText(
                      titile,
                      maxLines: 1, // Ensures the text does not wrap
                      minFontSize:
                          10, // Set the minimum font size you want to allow
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(letterSpacing: 0.5, fontSize: 15.0),
                    ),
                    Text(
                      total_price,
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
