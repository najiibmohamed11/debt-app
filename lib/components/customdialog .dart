import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(
          minHeight: 200.0,
          maxHeight: MediaQuery.of(context).size.height * 0.3,
        ),
        child: AlertDialog(
          title: Text(
            title,
            style: TextStyle(color: Colors.red),
          ),
          content: Text(content),
          actions: [
            MaterialButton(
              onPressed: onPressed,
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
