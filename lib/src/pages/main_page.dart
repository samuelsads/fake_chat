import 'package:fake_chat/src/pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:locally/locally.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fake Chat'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const ChatPage())),
              icon: const Icon(Icons.chat))
        ],
      ),
      body: const Center(
          child: Text('Welcome to Fake Chat',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))),
    );
  }
  
}
