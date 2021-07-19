import 'select_group_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'conversation_detail.dart';
import 'group_detail.dart';
import 'action.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'realgroupdetail.dart';
class friends{

  String name;
  String status;
  friends({required this.name,required this.status});
}
class Friend extends StatefulWidget {
  Friend({ required this.id}) ;
  final String id;
  List<friends> Friends=[];
  @override
  _ChatPageState createState() => _ChatPageState();
}
String _localhost() {
  if (Platform.isAndroid)
    return 'http://192.168.1.26:7878/getgroup';
  else // for iOS simulator
    return 'http://192.168.1.26:7878/getgroup';
}

class _ChatPageState extends State<Friend> {
  List<friends> Friends=[];
  void initState() {
    super.initState();
    getuser();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Conversations",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.deepPurple[200],
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.add,color: Colors.deepPurple,size: 20,),
                          SizedBox(width: 2,),
                          TextButton(onPressed: (){
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => SelectGroupmember(id:widget.id )),
                            );
                          }, child: Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16,left: 16,right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  prefixIcon: Icon(Icons.search,color: Colors.grey.shade600, size: 20,),
                  filled: true,
                  fillColor: Colors.grey.shade100,
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
            ListView.builder(
              itemCount: Friends.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 16),
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return GroupList(
                  id: widget.id,
                  name: Friends[index].name,
                  indexx: 0,
                  status: Friends[index].status,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  Future getuser() async{
    final url=Uri.parse(_localhost());
    var response = await http.get(url);
    List <dynamic>data= jsonDecode(response.body);
    data.forEach((element) {
      setState(() {
        if(element['member'].contains(widget.id)){
          Friends=[...Friends, friends(name: element['groupname'], status: element['lastemessage'])];
        }
        // if(element['name'] != widget.id){
        //   Friends=[...Friends, friends(name: element['name'], status: element['status'])];
        // }
        // else{
        //   print('myself');
        // }
      });
    });
  }
}