import 'package:flutter/material.dart';
import 'chat.dart';
import 'action.dart';
import 'mainpage.dart';
class LoginPage extends StatelessWidget {
  // const LoginPage({Key? key}) : super(key: key);
  final email= TextEditingController();
  final pw = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Chat App"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('images/logo.png')),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Please enter the email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextFormField(
                controller: pw,
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.deepPurple, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  //
                  // Navigator.pushReplacementNamed(context, '/content');
                  login(context,email.text,pw.text);
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            TextButton(
              onPressed: (){
                Navigator.pushReplacementNamed(context, '/content');
                // makeGetRequest();
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.deepPurple, fontSize: 15),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            // Text('New User? Create Account'),
            TextButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: Text(
                'New User? Create Account',
                style: TextStyle(color: Colors.deepPurple, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
