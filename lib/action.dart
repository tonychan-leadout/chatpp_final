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
  if(response.body == 'error'){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title:  Text('Login Failed'),
        content:  Text('Please ensure your password and email are both correct'),
        actions: <Widget>[

          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            child: const Text('OK'),
          ),

        ],
      ),
    );
  }
  else{
    if(jsonDecode(response.body)[2] == email){
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title:  Text('User Name :${jsonDecode(response.body)[0]}'),
          content:  Text('Login Successful'),
          actions: <Widget>[

            TextButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(
                builder: (context) => content(id: jsonDecode(response.body)[0],status: jsonDecode(response.body)[3],indexx: 0,),

              )
              ),
              child: const Text('OK'),
            ),

          ],
        ),
      );

      // Navigator.push(
      //     context, MaterialPageRoute(
      //   builder: (context) => ChatPage(id: jsonDecode(response.body)[0],sendid: jsonDecode(response.body)[1],),
      // )
      // );
    }
  }

}
Future register(context,password,email,name) async {
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
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title:  Text('Register Successful'),
      content:  Text('Go to login now'),
      actions: <Widget>[

        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          child: const Text('Go'),
        ),

      ],
    ),
  );
}
Future addgroupchat(context,name,member,group) async {
  final url = Uri.parse(_localhostss());
  //Response response = await get(url);
  //print(response.body);
  int receiver= 02;
  final json = '{"creator":"$name","member": "$member","groupname" :"$group"}';
  final response = await post(Uri.parse(_localhostssss()), headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  }, body: json);
  // print('Status code: ${response.statusCode}');
  print(response.body);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => content(id:name ,status: 'Hello i am ok',indexx: 1,)),
  );
}
String _localhostssss() {
  if (Platform.isAndroid)
    return 'http://35.220.163.89:7878/group';
  else // for iOS simulator
    return 'http://35.220.163.89:7878/group';
}
String _localhost() {
  if (Platform.isAndroid)
    return 'http://35.220.163.89:7878/login';
  else // for iOS simulator
    return 'http://35.220.163.89:7878/login';
}
String _localhostss() {
  if (Platform.isAndroid)
    return 'http://35.220.163.89:7878/register';
  else // for iOS simulator
    return 'http://35.220.163.89:7878/register';
}
