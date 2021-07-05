import 'package:test123/mainpage.dart';

import 'chat.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      // home: LoginPage(),
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => Register(),
        '/chat': (context) => ChatPage(id: 's',sendid: '3',),
        '/content': (context)=> content(id: 'mom',sendid: 'tony', status: 'hello i am use chat',),
      },

    );
  }
}