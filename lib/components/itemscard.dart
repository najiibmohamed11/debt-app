
import 'package:flutter/material.dart';

class ItemsCard extends StatelessWidget {
  ItemsCard({
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
            child: priceindollar == ""
                ? Text("")
                : Text(
                    "\$$priceindollar",
                    style:
                        TextStyle(fontSize: 17.0, fontWeight: FontWeight.w400),
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
