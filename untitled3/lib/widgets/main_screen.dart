import 'package:flutter/material.dart';

import 'chat_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 10,
            color: Colors.black,
          ),
          const Chat()
        ]));
  }
}
