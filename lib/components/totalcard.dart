import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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
