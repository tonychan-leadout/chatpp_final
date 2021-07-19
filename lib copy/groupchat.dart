import 'dart:convert';
import 'mainpage.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/cupertino.dart';
import 'conversation_detail.dart';
import 'conversation.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' ;
import 'group_detail.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ChatPage extends StatefulWidget{
  @override
  ChatPage({ required this.id,required this.sendid,required this.unread}) ;
  final String id;
  final String sendid;
  final int unread;
  State<StatefulWidget> createState() {
    return ChatPageState();
  }
}

class ChatPageState extends State<ChatPage>{
  int count=0;
  late IOWebSocketChannel channel; //channel varaible for websocket
  late bool connected;
  late bool istoday;// boolean value to track connection status
  var now = DateTime.now();
  var hour = DateTime.now().hour.toString();
  var min = DateTime.now().minute.toString();
  var month = DateTime.now().month.toString();
  var day = DateTime.now().day.toString();
  int hourr= DateTime.now().hour;
  late ScrollController _scrollController;
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
    _scrollController = new ScrollController();
    channelconnect();

    super.initState();
  }

  channelconnect(){ //function to connect
    try{
      channel = IOWebSocketChannel.connect("ws://192.168.1.26:6060/${widget.sendid}"); //channel IP : Port
      channel.stream.listen((message) {
        var timesss;
        int hourr= DateTime.now().hour;
        if(min.length ==1){
          min="0$min";
        }
        if(hour.length ==1){
          hour="0$hour";
        }
        if(month.length ==1){
          month="0$month";
        }
        if(day.length ==1){
          day="0$day";
        }
        if(hourr >=12){
          timesss='pm';
        }
        else{
          timesss='am';
        }
        print(message);
        setState(() {
          if(message == "connected"){
            connected = true;
            setState(() { });
            print("Connection establised.");
          }else if(message == "send:success"){
            setState(() {
              msgtext.text = "";
            });
          }else if(message == "send:error"){
            print("Message send error");
          }else if (message.substring(0, 13) == "{'cmd':'send'") {
            print("Message data:");
            message = message.replaceAll(RegExp("'"), '"');
            var jsondata = json.decode(message);
            // print('ll${jsondata["sendid"]}');
            // print('ss${widget.sendid}');
            // print(widget.id);
            if(jsondata["sendid"] == widget.sendid && jsondata['userid'] !=widget.id){
              setState(() {
                if(msglist.length ==0){
                  msglist.add(MessageData( //on message recieve, add data to model
                      msgtext: jsondata["msgtext"],
                      userid: jsondata["userid"],
                      isme: false,
                      sendid: jsondata["sendid"],
                      time: ('$month-$day-$hour:${min}$timesss'),
                      istoday: true,
                      today: false,
                      ismessageread: false
                  )
                  );
                }
                else{
                  if(msglist[msglist.length-1].time.substring(0,5)=='$month-$day'){
                    msglist.add(MessageData( //on message recieve, add data to model
                        msgtext: jsondata["msgtext"],
                        userid: jsondata["userid"],
                        isme: false,
                        sendid: jsondata["sendid"],
                        time: ('$month-$day-$hour:${min}$timesss'),
                        istoday: true,
                        today: true,
                        ismessageread: false
                    )
                    );
                  }
                  else{
                    msglist.add(MessageData( //on message recieve, add data to model
                        msgtext: jsondata["msgtext"],
                        userid: jsondata["userid"],
                        isme: false,
                        sendid: jsondata["sendid"],
                        time: ('$month-$day-$hour:${min}$timesss'),
                        istoday: true,
                        today: false,
                        ismessageread: false
                    )
                    );
                  }

                }

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
    var now = DateTime.now();
    var hour = DateTime.now().hour.toString();
    var min = DateTime.now().minute.toString();
    var month = DateTime.now().month.toString();
    var day = DateTime.now().day.toString();
    int hourr= DateTime.now().hour.toInt();
    if(connected == true){
      print(hourr.runtimeType);
      String msg = "{'auth':'$auth','cmd':'send','userid':'$id', 'msgtext':'$sendmsg','receiver':'$sendid'}";
      setState(() {

        if(min.length ==1){
          min="0$min";
        }
        if(hour.length ==1){
          hour="0$hour";
        }
        if(month.length ==1){
          month="0$month";
        }
        if(day.length ==1){
          day="0$day";
        }
        print('$month-$day-$hour:${min}am');
        msgtext.text = "";

        // if(hourr > 12){
        //   msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ("$hour:${min} pm"),istoday: true,today: false));
        // }
        // else{
        //   msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ("$hour:${min} am"),istoday: true,today: false));
        // }
        if(msglist.length ==0){
          if(hour[0] == '0'){
            msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}am'),istoday: true,today: false,ismessageread: false));
          }
          if(hour[0] == '2'){
            msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}pm'),istoday: true,today: false,ismessageread: false));
          }
          if(hour[0] == '1'){
            if(hour[1]== '1'||hour[1]== '0'){
              msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}am'),istoday: true,today: false,ismessageread: false));
            }
            else{
              msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}pm'),istoday: true,today: false,ismessageread: false));
            }
          }
        }
        else{
          if(msglist[msglist.length-1].time.substring(0,5)=='$month-$day'){
            if(hour[0] == '0'){
              msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}am'),istoday: true,today: true,ismessageread: false));
            }
            if(hour[0] == '2'){
              msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}pm'),istoday: true,today: true,ismessageread: false));
            }
            if(hour[0] == '1'){
              if(hour[1]== '1'||hour[1]== '0'){
                msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}am'),istoday: true,today: true,ismessageread: false));
              }
              else{
                msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}pm'),istoday: true,today: true,ismessageread: false));
              }
            }
          }
          else{
            if(hour[0] == '0'){
              msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}am'),istoday: true,today: false,ismessageread: false));
            }
            if(hour[0] == '2'){
              msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}pm'),istoday: true,today: false,ismessageread: false));
            }
            if(hour[0] == '1'){
              if(hour[1]== '1'||hour[1]== '0'){
                msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}am'),istoday: true,today: false,ismessageread: false));
              }
              else{
                msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ('$month-$day-$hour:${min}pm'),istoday: true,today: false,ismessageread: false));
              }
            }
          }
        }
      }

        // else{
        //   if(hour[0] == '1'){
        //     msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ("$hour:${min} am"),istoday: true,today: false));
        //     // if(hour[1]== '1'||hour[1]== '0'){
        //     //   msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ("$hour:${min} am"),istoday: true,today: false));
        //     // }
        //     // else{
        //     //   msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ("$hour:${min} pm"),istoday: true,today: false));
        //     // }
        //   }
        //   else{
        //     msglist.add(MessageData(msgtext: sendmsg, userid: widget.id, isme: true,sendid: widget.sendid, time: ("$hour:${min} pm"),istoday: true,today: false));
        //   }
        // }
      );
      channel.sink.add(msg); //send message to reciever channel
    }else{
      channelconnect();
      print("Websocket is not connected.");
    }
  }
  Future clean() async{
    final json = '{"id":"${widget.id}","receiver": "${widget.sendid}"}';
    final response = await post(Uri.parse(_localhost()), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: json);
  }
  Future getmymsg() async {
    int count=0;

    late bool istoday;
    final url = Uri.parse(_localhostss());
    //Response response = await get(url);
    //print(response.body);
    final json = '{"id":"${widget.id}","receiver": "${widget.sendid}"}';
    final response = await post(Uri.parse(_localhostss()), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: json);
    // print('Status code: ${response.statusCode}');
    List<dynamic>dayss=[];
    List <dynamic>data= jsonDecode(response.body);
    print( jsonDecode(response.body)[0]);
    data.forEach((element) {
      if(month.length==1){
        month='0'+month;
      }
      if(day.length==1){
        day='0'+day;
      }
      if (count ==0){
        istoday =false;
        count=count+1;
      }
      else{
        if (data[count]['date'].substring(5,10) == data[count-1]['date'].substring(5,10)){
          istoday=true;
          count=count+1;
        }
        else{
          istoday=false;
          count=count+1;
        }
      }
      if(element['name'] == widget.id){
        setState(() {
          if(element['date'][11] == '0'){

            if((element['date'].substring(5,10)) == '$month-$day'){
              msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: true,today: istoday,ismessageread: false)];
            }
            else
            {
              msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: false,today: istoday,ismessageread: false)];
              // print(element['date']);
              // print('hi');
            }
          }
          else{
            if(element['date'][12]=='1'){
              if(element['date'].toString().substring(5,10) == ("$month-$day")){
                if(element['date'][11] =='1'){
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: true,today: istoday,ismessageread: false)];
                }
                else{
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: true,today: istoday,ismessageread: false)];
                }

              }
              else{
                if(element['date'][11] =='1'){
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: false,today: istoday,ismessageread: false)];
                }
                else{
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: false,today: istoday,ismessageread: false)];
                }
              }
            }
            else{
              if(element['date'].toString().substring(5,10) == ("$month-$day")){
                if(element['date'][12] =='0'){
                  if(element['date'][11]=='1'){
                    msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: true,today: istoday,ismessageread: false)];
                  }
                  else{
                    msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: true,today: istoday,ismessageread: false)];
                  }
                }
                else{
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: true,today: istoday,ismessageread: false)];
                }
              }
              else{
                if(element['date'][12] =='0'){
                  if(element['date'][11]=='1'){
                    msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: false,today: istoday,ismessageread: false)];
                  }
                  else{
                    msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: false,today: istoday,ismessageread: false)];
                  }
                }
                else{
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: true, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: false,today: istoday,ismessageread: false)];
                }
                // print(element['date']);
              }
            }

          }

        });
      }
      else{
        setState(() {
          if(element['date'][11] == '0'){

            if((element['date'].substring(5,10)) == '$month-$day'){
              msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: true,today: istoday,ismessageread: false)];
            }
            else
            {
              msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: false,today: istoday,ismessageread: false)];
              // print(element['date']);
              // print('hi');
            }
          }
          else{
            if(element['date'][12]=='1'){
              if(element['date'].toString().substring(5,10) == ("$month-$day")){
                if(element['date'][11] =='1'){
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: true,today: istoday,ismessageread: false)];
                }
                else{
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: true,today: istoday,ismessageread: false)];
                }

              }
              else{
                if(element['date'][11] =='1'){
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: false,today: istoday,ismessageread: false)];
                }
                else{
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: false,today: istoday,ismessageread: false)];
                }
              }
            }
            else{
              if(element['date'].toString().substring(5,10) == ("$month-$day")){
                if(element['date'][12] =='0'){
                  if(element['date'][11]=='1'){
                    msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: true,today: istoday,ismessageread: false)];
                  }
                  else{
                    msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: true,today: istoday,ismessageread: false)];
                  }
                }
                else{
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: true,today: istoday,ismessageread: false)];
                }
              }
              else{
                if(element['date'][12] =='0'){
                  if(element['date'][11]=='1'){
                    msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}am"),istoday: false,today: istoday,ismessageread: false)];
                  }
                  else{
                    msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: false,today: istoday,ismessageread: false)];
                  }
                }
                else{
                  msglist=[...msglist,MessageData(msgtext: element['message'], userid: element['name'], isme: false, sendid: element['receiver'],time: ("${(element['date']).substring(5,16)}pm"),istoday: false,today: istoday,ismessageread: false)];
                }
                // print(element['date']);
              }
            }

          }

        });
      }
    });

  }
  String _localhostss() {
    if (Platform.isAndroid)
      return 'http://192.168.1.26:7878/getgroupmsg';
    else // for iOS simulator
      return 'http://192.168.1.26:7878/getgroupmsg';
  }
  String _localhost() {
    if (Platform.isAndroid)
      return 'http://192.168.1.26:7878/clean';
    else // for iOS simulator
      return 'http://192.168.1.26:7878/clean';
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
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
    else{
      Timer(Duration(milliseconds: 680), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }

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
                  <Widget>[ SizedBox(height: 4,),Text("${widget.sendid} ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),SizedBox(height: 6,)]
                      :<Widget>[ SizedBox(height: 4,),Text("${widget.sendid} ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19),),SizedBox(height: 6,)]
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              /*Navigator.push(
                  context, MaterialPageRoute(
                builder: (context) => New(id:widget.id ),
              )
              );*/
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => content(id:widget.id ,status: 'Hello i am ok',indexx: 0,)),
              );
            },
          ),
          //leading: Icon(Icons.circle, color: connected?Colors.greenAccent:Colors.redAccent),
          //if app is connected to node.js then it will be gree, else red.
          titleSpacing: 0,
          backgroundColor: Colors.deepPurple[600],
          actions: <Widget>[
            //FriendList(name: widget.id, status: 'status', sendid: 'sendid', id: 'id'),

          ],
        ),
        body:
        Container(
            child: Stack(children: [

              Positioned(
                  top:0,bottom:70,left:0, right:0,
                  child:Container(
                      padding: EdgeInsets.all(15),
                      child: SingleChildScrollView(
                          controller: _scrollController,
                          child:Column(
                            children: [
                              Container(
                                  child: Column(
                                    children: msglist.map((onemsg){
                                      count=count+1;
                                      return Column(
                                        children: [
                                          if(count == msglist.length-widget.unread+1 && widget.unread !=0)
                                            Container(
                                                margin: EdgeInsets.all(5),
                                                padding: EdgeInsets.all(5),
                                                height: 30,
                                                width: 200,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[400], borderRadius: BorderRadius.circular(20)),
                                                child:
                                                Column(
                                                  children: [
                                                    Text("${widget.unread.toString().toWord(
                                                        lang: NumStrLanguage.English)} unread messages")
                                                  ],
                                                )
                                            ),
                                          if(!onemsg.today)(
                                              Container(
                                                  margin: EdgeInsets.all(5),
                                                  padding: EdgeInsets.all(5),
                                                  height: 30,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey[400], borderRadius: BorderRadius.circular(20)),
                                                  child:
                                                  Column(
                                                    children: [
                                                      Text(onemsg.istoday?('Today'):(onemsg.time.substring(0,5)))
                                                    ],
                                                  )
                                              )
                                          ),
                                          Container(
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
                                                        if(onemsg.userid != widget.id)
                                                        Container(
                                                          margin: EdgeInsets.only(top:2,bottom:2),
                                                          child: Text( onemsg.userid, style: TextStyle(fontSize: 15,color: Colors.lightBlueAccent)),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(top:5,bottom:5),
                                                          child: Text( onemsg.msgtext, style: TextStyle(fontSize: 17,color: Colors.white)),
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Spacer(),
                                                            Text(onemsg.time.substring(6,13),style: TextStyle(color: Colors.grey,),)
                                                          ],
                                                        )
                                                      ],),
                                                  )
                                              )
                                          ),
                                        ],
                                      );
                                      // return Container(
                                      //     margin: EdgeInsets.only( //if is my message, then it has margin 40 at left
                                      //       left: onemsg.isme?40:0,
                                      //       right: onemsg.isme?0:40, //else margin at right
                                      //     ),
                                      //     child: Card(
                                      //         color: onemsg.isme?Colors.deepPurple[700]:Colors.grey[700],
                                      //         shape: RoundedRectangleBorder(
                                      //           borderRadius: BorderRadius.circular(25),
                                      //         ),
                                      //         //if its my message then, blue background else red background
                                      //         child: Container(
                                      //           width: double.infinity,
                                      //           padding: EdgeInsets.all(15),
                                      //
                                      //           child: Column(
                                      //             crossAxisAlignment: CrossAxisAlignment.start,
                                      //             children: [
                                      //
                                      //               /*Container(
                                      //                   child:Text(onemsg.isme?"ID: ME":"ID: " + onemsg.userid)
                                      //               ),*/
                                      //
                                      //               Container(
                                      //                 margin: EdgeInsets.only(top:10,bottom:10),
                                      //                 child: Text( onemsg.msgtext, style: TextStyle(fontSize: 17,color: Colors.white)),
                                      //               ),
                                      //               Row(
                                      //                 crossAxisAlignment: CrossAxisAlignment.end,
                                      //                 children: [
                                      //                   Spacer(),
                                      //                   Text(onemsg.time.substring(6,13),style: TextStyle(color: Colors.grey,),)
                                      //                 ],
                                      //               )
                                      //             ],),
                                      //         )
                                      //     )
                                      // );
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
  String time;
  bool isme;
  bool istoday;
  bool today;
  bool ismessageread;
  MessageData({required this.msgtext, required this.userid, required this.isme,required this.sendid, required this.time,required this.istoday,required this.today,required this.ismessageread,});

}