import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/cupertino.dart';
import 'conversation_detail.dart';

import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' ;
import 'friend_detail.dart';

class ChatPage extends StatefulWidget{
  @override
  ChatPage({ required this.id,required this.sendid}) ;
  final String id;
  final String sendid;
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage>{

  late IOWebSocketChannel channel; //channel varaible for websocket
  late bool connected; // boolean value to track connection status

  // String myid = "111"; //my id
  // String recieverid = "222"; //reciever id
  // swap myid and recieverid value on another mobile to test send and recieve
  String auth = "chatapphdfgjd34534hjdfk"; //auth key

  List<MessageData> msglist = [];

  TextEditingController msgtext = TextEditingController();

  @override
  void initState() {
    connected = false;
    msgtext.text = "";
    getmymsg();
    channelconnect();
    super.initState();
  }

  channelconnect(){ //function to connect
    try{
      channel = IOWebSocketChannel.connect("ws://192.168.1.26:6060/${widget.id}"); //channel IP : Port
      channel.stream.listen((message) {
        print(message);
        setState(() {
          if(message == "connected"){
            connected = true;
            setState(() { });
            print("Connection establised.");
          }else if(message == "send:success"){
            print("Message send success");
            setState(() {
              msgtext.text = "";
            });
          }else if(message == "send:error"){
            print("Message send error");
          }else if (message.substring(0, 6) == "{'cmd'") {
            print("Message data");
            message = message.replaceAll(RegExp("'"), '"');
            var jsondata = json.decode(message);
            if(jsondata["userid"] == widget.sendid){
              setState(() {
                msglist.add(MessageData( //on message recieve, add data to model
                  msgtext: jsondata["msgtext"],
                  userid: jsondata["userid"],
                  isme: false,
                  sendid: jsondata["sendid"],
                )
                );
              });

            }

            setState(() { //update UI after adding data to message model

            });
          }
        });
      },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },);
    }catch (_){
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendmsg(String sendmsg, String id,String sendid) async {
    if(connected == true){
      String msg = "{'auth':'$auth','cmd':'send','userid':'$id', 'msgtext':'$sendmsg','receiver':'$sendid'}";
      setState(() {
        msgtext.text = "";
        msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid));
      });
      channel.sink.add(msg); //send message to reciever channel
    }else{
      channelconnect();
      print("Websocket is not connected.");
    }
  }
  Future getmymsg() async {
    final url = Uri.parse(_localhostss());
    //Response response = await get(url);
    //print(response.body);
    final json = '{"id":"${widget.id}","receiver": "${widget.sendid}"}';
    final response = await post(Uri.parse(_localhostss()), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: json);
    // print('Status code: ${response.statusCode}');
    List <dynamic>data= jsonDecode(response.body);
    print( jsonDecode(response.body)[0]);
    data.forEach((element) {
      if(element['name'] == widget.id){
        setState(() {
          msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'])];
        });
      }
      else{
        setState(() {
          msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'])];
        });
      }
    });

  }
  String _localhostss() {
    if (Platform.isAndroid)
      return 'http://192.168.1.26:7878/getmsg';
    else // for iOS simulator
      return 'http://192.168.1.26:7878/getmsg';
  }
  /*Future getuser() async{
    final url=Uri.parse(_localhost());
    var response = await http.get(url);
    List <dynamic>data= jsonDecode(response.body);
    data.forEach((element) {
      setState(() {
        msglist=[...msglist, friends(name: element['name'], status: element['status'])];
      });
    });
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: ExactAssetImage('images/user.png'),
                maxRadius: 20,
              ),
              SizedBox(width: 10,),
              Column(
                  children: connected?
                  <Widget>[ SizedBox(height: 4,),Text("${widget.sendid} ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),SizedBox(height: 6,),Text('online',style: TextStyle(fontSize: 13),)]
                      :<Widget>[ SizedBox(height: 4,),Text("${widget.sendid} ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),SizedBox(height: 6,),Text('offline',style: TextStyle(fontSize: 13),)]
              ),
            ],
          ),
          //leading: Icon(Icons.circle, color: connected?Colors.greenAccent:Colors.redAccent),
          //if app is connected to node.js then it will be gree, else red.
          titleSpacing: 0,
          backgroundColor: Colors.deepPurple[600],
          actions: <Widget>[
            //FriendList(name: widget.id, status: 'status', sendid: 'sendid', id: 'id'),
            SizedBox(
              height: 30,
              width: 40,
              child: FloatingActionButton(

                  child: Icon(Icons.arrow_back),
                  backgroundColor: Colors.green,
                  onPressed: () {
                    Navigator.pushReplacementNamed(
                      context, '/',
                    );
                  }
              ),
            )
          ],
        ),
        body: Container(
            child: Stack(children: [
              Positioned(
                  top:0,bottom:70,left:0, right:0,
                  child:Container(
                      padding: EdgeInsets.all(15),
                      child: SingleChildScrollView(
                          child:Column(children: [

                            /*Container(
                              child:Text("Your Messages", style: TextStyle(fontSize: 20)),
                            ),*/

                            Container(
                                child: Column(
                                  children: msglist.map((onemsg){
                                    return Container(
                                        margin: EdgeInsets.only( //if is my message, then it has margin 40 at left
                                          left: onemsg.isme?40:0,
                                          right: onemsg.isme?0:40, //else margin at right
                                        ),
                                        child: Card(
                                            color: onemsg.isme?Colors.deepPurple[700]:Colors.grey[700],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(25),
                                            ),
                                            //if its my message then, blue background else red background
                                            child: Container(
                                              width: double.infinity,
                                              padding: EdgeInsets.all(15),

                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  /*Container(
                                                      child:Text(onemsg.isme?"ID: ME":"ID: " + onemsg.userid)
                                                  ),*/

                                                  Container(
                                                    margin: EdgeInsets.only(top:10,bottom:10),
                                                    child: Text( onemsg.msgtext, style: TextStyle(fontSize: 17,color: Colors.white)),
                                                  ),

                                                ],),
                                            )
                                        )
                                    );
                                  }).toList(),
                                )
                            )
                          ],)
                      )
                  )
              ),

              Positioned(  //position text field at bottom of screen

                bottom: 0, left:0, right:0,
                child: Container(
                    color: Colors.black12,
                    height: 70,
                    child: Row(children: [

                      Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: TextField(
                              controller: msgtext,
                              decoration: InputDecoration(
                                  hintText: "Enter your Message"
                              ),
                            ),
                          )
                      ),

                      Container(
                          margin: EdgeInsets.all(10),
                          child: ElevatedButton(
                            child:Icon(Icons.send),
                            onPressed: (){
                              if(msgtext.text != ""){
                                sendmsg(msgtext.text, widget.id,widget.sendid); //send message with webspcket
                              }else{
                                print("Enter message");
                              }
                            },
                          )
                      )
                    ],)
                ),
              )
            ],)
        )
    );
  }
}

class MessageData{ //message data model
  String msgtext, userid,sendid;
  bool isme;
  MessageData({required this.msgtext, required this.userid, required this.isme,required this.sendid});

}