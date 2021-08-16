import 'package:test123/mainpage.dart';

import 'chat.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'register.dart';
import 'select_group_member.dart';
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
        '/chat': (context) => ChatPage(id: 's',sendid: '3',unread: 0,),
        '/content': (context)=> content(id: 'mom', status: 'hello i am use chat',indexx: 0,),
      },

    );
  }
}