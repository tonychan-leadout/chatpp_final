import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'chat.dart';
import 'mainpage.dart';
Future login(context,email,password) async {
  final url = Uri.parse(_localhost());
  //Response response = await get(url);
  //print(response.body);
  final json = '{"email": "$email", "password": "$password"}';
  final response = await post(Uri.parse(_localhost()), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  }, body: json);
  // print('Status code: ${response.statusCode}');
  print(jsonDecode(response.body));
  if(jsonDecode(response.body)[2] == email){
    Navigator.push(
        context, MaterialPageRoute(
      builder: (context) => content(id: jsonDecode(response.body)[0],sendid: jsonDecode(response.body)[1],status: jsonDecode(response.body)[3]),

    )
    );
    // Navigator.push(
    //     context, MaterialPageRoute(
    //   builder: (context) => ChatPage(id: jsonDecode(response.body)[0],sendid: jsonDecode(response.body)[1],),
    // )
    // );
  }
}
Future register(password,email,name) async {
  final url = Uri.parse(_localhostss());
  //Response response = await get(url);
  //print(response.body);
  int receiver= 02;
  final json = '{"name":"$name","email": "$email", "password": "$password","receiver" :"tony","status" :"Hello i am use chat"}';
  final response = await post(Uri.parse(_localhostss()), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  }, body: json);
  // print('Status code: ${response.statusCode}');
  print( response.body);
}
String _localhost() {
  if (Platform.isAndroid)
    return 'http://192.168.1.26:7878/login';
  else // for iOS simulator
    return 'http://192.168.1.26:7878/login';
}
String _localhostss() {
  if (Platform.isAndroid)
    return 'http://192.168.1.26:7878/register';
  else // for iOS simulator
    return 'http://192.168.1.26:7878/register';
}
