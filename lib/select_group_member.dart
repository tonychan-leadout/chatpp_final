import 'mainpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'conversation_detail.dart';
import 'group_detail.dart';
import 'group_name.dart';
import 'action.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class friends{
  int indexx;
  String name;
  String status;
  friends({required this.name,required this.status, required this.indexx});
}
class SelectGroupmember extends StatefulWidget {
  SelectGroupmember({ required this.id}) ;
  final String id;
  List<friends> Friends=[];
 var Member=[];
  @override
  _ChatPageState createState() => _ChatPageState();
}
String _localhost() {
  if (Platform.isAndroid)
    return 'http://35.220.163.89:7878/get';
  else // for iOS simulator
    return 'http://35.220.163.89:7878/get';
}

class _ChatPageState extends State<SelectGroupmember> {
  List<friends> Friends=[];
  List<String> Member=[];
  void initState() {
    super.initState();
    getuser();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        title:Row(
          children: [
            Text('Group Member'),
          ],
        ),
        leading:  IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => content(id:widget.id ,status: 'Hello i am ok',indexx: 1,)),
        );
      },
    ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Groupname(id:widget.id, Name: Member, )),
              );
            },
          ),
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
                return  GestureDetector(
                  onTap: (){
                    setState(() {
                      if(Friends[index].indexx==0){
                        Friends[index].indexx=1;
                        print(Friends[index].name);
                        Member=[...Member, Friends[index].name];
                        // SelectGroupmember(id: widget.id,).Member=[...SelectGroupmember(id: widget.id,).Member,widget.name];
                        print(Member);
                        // SelectGroupmember(id: widget.id,).Member.add(widget.name);
                      }
                      else{
                        Friends[index].indexx=0;
                        Member.remove(Friends[index].name);
                        print(Member);
                        // SelectGroupmember(id: widget.id,).Member.remove(widget.name);
                      }
                    });
                    // Navigator.push(
                    //     context, MaterialPageRoute(
                    //   builder: (context) => ChatPage(id: widget.id,sendid: widget.name,unread: 0,),
                    //
                    // )
                    // );
                  },
                  child:

                  Container(
                    decoration: BoxDecoration(
                      color:  Friends[index].indexx == 1 ? Colors.grey[200] : Colors.white,
                      border:  Friends[index].indexx == 1 ? Border.all(color: Colors.grey):Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    padding: EdgeInsets.only(left: 16,right: 16,top: 10,bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: ExactAssetImage('images/user.png'),
                                maxRadius: 30,
                              ),
                              SizedBox(width: 16,),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(Friends[index].name, style: TextStyle(fontSize: 16),),
                                      SizedBox(height: 6,),
                                      Text(Friends[index].status,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, ),)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
        if(element['name'] != widget.id){
          Friends=[...Friends, friends(name: element['name'], status: element['status'], indexx: 0)];
        }
        else{
          print('myself');
        }
      });
    });
  }
}