import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> messages = [];
  late final IOWebSocketChannel channel;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  void _connectToWebSocket() {
    channel = IOWebSocketChannel.connect('ws://your-backend-url/');
    channel.stream.listen(
      (dynamic message) {
        setState(() {
          messages.add(message.toString());
        });
      },
      onError: (error) {
        // Handle WebSocket errors
        print('WebSocket error: $error');
        _showErrorSnackbar('WebSocket error: $error');
        // Reconnect after a delay
        Future.delayed(Duration(seconds: 5), () {
          _connectToWebSocket();
        });
      },
      onDone: () {
        print('WebSocket closed');
        _showErrorSnackbar('WebSocket connection closed');
        Future.delayed(Duration(seconds: 5), () {
          _connectToWebSocket();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Real-time Chat"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isSent = true;

                return Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  alignment:
                      isSent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isSent ? Colors.green : Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      messages[index],
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.green,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    expands: true,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter Message",
                      contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      try {
        channel.sink.add(_textEditingController.text);
        setState(() {
          messages.add(_textEditingController.text);
          _textEditingController.clear();
        });
      } catch (e) {
        print('Error sending message: $e');
        _showErrorSnackbar('Error sending message: $e');
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    channel.sink.close(status.normalClosure);
    super.dispose();
  }
}
