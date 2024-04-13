import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              DebtorsCard(),
              Divider()
            ],
          ),
        ),
      ),
    );
  }
}

class DebtorsCard extends StatelessWidget {
  const DebtorsCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 70,
        height: 90,
        decoration: BoxDecoration(
            color: Color(0xffF1EBE2),
            borderRadius: BorderRadius.circular(12.0)),
        child: Image.asset("images/hijabgirl.png"),
      ),
      title: Text(
        "Amina",
        style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Text("april"),
      trailing: Column(
        children: [
          Text(
            "\$12.0",
            style: TextStyle(
                fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Text(
            "20k",
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
