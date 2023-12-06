import 'package:flutter/material.dart';

class ChatChip extends StatelessWidget {
  const ChatChip({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0), // Add padding for better appearance
      decoration: BoxDecoration(
        color: Colors.blue, // You can customize the background color
        borderRadius: BorderRadius.circular(12.0), // Add rounded corners
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white, // You can customize the text color
        ),
      ),
    );
  }
}
