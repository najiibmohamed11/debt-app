import 'package:flutter/material.dart';

class Total extends StatelessWidget {
  Total({
    super.key,
    required this.text,
    required this.total,
  });
  String text;
  String total;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300),
        ),
        Spacer(),
        Text(
          total,
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}