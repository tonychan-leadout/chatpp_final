import 'mainpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'select_group_member.dart';
import 'conversation_detail.dart';
import 'group_detail.dart';

import 'action.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class friends{

  String name;
  String status;
  friends({required this.name,required this.status});
}
class Groupname extends StatefulWidget {
  Groupname({ required this.id, required this.Name}) ;
  final String id;
  var Name=[];
  List<friends> Friends=[];
  @override
  _ChatPageState createState() => _ChatPageState();
}
String _localhost() {
  if (Platform.isAndroid)
    return 'http://35.220.163.89:7878/get';
  else // for iOS simulator
    return 'http://35.220.163.89:7878/get';
}

class _ChatPageState extends State<Groupname> {
  List<friends> Friends=[];
  final namee= TextEditingController();
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        title: Text('Create a Group'),
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SelectGroupmember(id:widget.id )),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () {
            widget.Name=[...widget.Name,widget.id];
            addgroupchat(context,widget.id,widget.Name,namee.text);
            print('ffff');
          }, child: Text('Create',style: TextStyle(fontSize: 14,color: Colors.white),))

        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                controller: namee,
                decoration: InputDecoration(
                  hintText: "   Enter the Group Name",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  filled: true,
                  fillColor: Colors.grey[300],
                  contentPadding: EdgeInsets.all(8),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: Colors.grey.shade100
                      )
                  ),
                ),
              ),
            ),
            Container(
              height: 120,
              child: ListView.builder(
                itemCount: widget.Name.length,
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index){
                  return GestureDetector(
                    onTap: (){
                      print('ggg');
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                      child:
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: ExactAssetImage('images/user.png'),
                            maxRadius: 25,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 7,
                              ),
                              Text("${widget.Name[index]}"),
                            ],
                          )

                        ],
                      ) ,
                    ),
                  );


                },
              ),
            )

          ],
        ),
      ),
    );
  }
}