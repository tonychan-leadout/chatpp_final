import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'conversation_detail.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' ;
class friends{

  String name;
  String text;
  friends({required this.name,required this.text});
}
class ChatUsers{
  String name;
  String messageText;
  String imageURL;
  String time;
  ChatUsers({required this.name,required this.messageText,required this.imageURL,required this.time});
}

class ChatPage extends StatefulWidget {
  ChatPage({ required this.id}) ;
  final String id;
  List<friends> Friends=[];
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<ChatUsers> Friends=[];
  late IOWebSocketChannel channel; //channel varaible for websocket
  late bool connected;
  String auth = "chatapphdfgjd34534hjdfk";
  void initState() {
    super.initState();
    getmymsg();
    channelconnect();
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
                    Text("Chat",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
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
                          Text("Add New",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
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
                return ConversationList(
                  id: widget.id,
                  name: Friends[index].name,
                  messageText: Friends[index].messageText,
                  imageUrl: Friends[index].imageURL,
                  time: Friends[index].time,
                  isMessageRead: true,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
  channelconnect(){ //function to connect
    try{
      channel = IOWebSocketChannel.connect("ws://192.168.0.137:6060/${widget.id}"); //channel IP : Port
      channel.stream.listen((message) {
        print(message);
        setState(() {
          if(message == "connected"){
            connected = true;
            setState(() { });
            print("Connection establised.");
          }
          else if (message.substring(0, 6) == "{'cmd'") {
            print("Message data");
            message = message.replaceAll(RegExp("'"), '"');
            var jsondata = json.decode(message);
            if (jsondata['cmd'] == 'add'){
              print('hi');
              setState(() {
                if(jsondata['sendid'] ==widget.id){
                  Friends.insert(0, ChatUsers(name: jsondata['receiver'], messageText: ('✓✓ ${jsondata['msgtext']}'), imageURL: 'imageURL', time: jsondata['date'].substring(11,16)));
                }
                else{
                  Friends.insert(0, ChatUsers(name: jsondata['sendid'], messageText: jsondata['msgtext'], imageURL: 'imageURL', time: jsondata['date'].substring(11,16)));
                }
              });
            }
            if(jsondata['cmd'] == 'update'){
                Friends.forEach((element) {
                    if (element.name == jsondata['sendid'] ) {
                      setState(() {
                        Friends.removeWhere((element) => element.name ==jsondata['sendid'] );
                        if(jsondata['sendid'] ==widget.id){
                          Friends.insert(0, ChatUsers(name: jsondata['receiver'], messageText: ('✓✓ ${jsondata['msgtext']}'), imageURL: 'imageURL', time: jsondata['date'].substring(11,16)));
                        }
                        else{
                          Friends.insert(0, ChatUsers(name: jsondata['sendid'], messageText: jsondata['msgtext'], imageURL: 'imageURL', time: jsondata['date'].substring(11,16)));
                        }
                      });
                    }
                    if ( element.name == jsondata['receiver']) {
                      setState(() {
                        Friends.removeWhere((element) => element.name ==jsondata['receiver'] );
                        if(jsondata['sendid'] ==widget.id){
                          Friends.insert(0, ChatUsers(name: jsondata['receiver'], messageText: ('✓✓ ${jsondata['msgtext']}'), imageURL: 'imageURL', time: jsondata['date'].substring(11,16)));
                        }
                        else{
                          Friends.insert(0, ChatUsers(name: jsondata['sendid'], messageText: jsondata['msgtext'], imageURL: 'imageURL', time: jsondata['date'].substring(11,16)));
                        }
                      });
                    }
              });
            }
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
  Future getmymsg() async {
    final url = Uri.parse(_localhostss());
    //Response response = await get(url);
    //print(response.body);
    final json = '{"id":"${widget.id}"}';
    var month = DateTime.now().month.toString();
    var day = DateTime.now().day.toString();
    if(month.length ==1){
      month="0$month";
    }
    if(day.length ==1){
      day="0$day";
    }
    final response = await post(Uri.parse(_localhostss()), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, body: json);
    // print('Status code: ${response.statusCode}');
    List <dynamic>data= jsonDecode(response.body);
    print( jsonDecode(response.body));
    data.reversed.toList().forEach((element) {
      setState(() {
        if(element['date'].substring(5,10)=='$month-$day'){
          if(element['sender'] == widget.id){
            Friends = [...Friends, ChatUsers(name: element['receiver'], messageText: ('✓✓ ${element['message']}'), imageURL: 'imageURL', time: element['date'].substring(11,16))];
          }
          else{
            Friends = [...Friends, ChatUsers(name: element['sender'], messageText: element['message'], imageURL: 'imageURL', time: element['date'].substring(11,16))];
          }
        }
        else{
          if(element['sender'] == widget.id){
            Friends = [...Friends, ChatUsers(name: element['receiver'], messageText: ('✓✓ ${element['message']}'), imageURL: 'imageURL', time: element['date'].substring(5,10))];
          }
          else{
            Friends = [...Friends, ChatUsers(name: element['sender'], messageText: element['message'], imageURL: 'imageURL', time: element['date'].substring(5,10))];
          }
        }

      });
    });
    /*data.forEach((element) {
        setState(() {
          Friends = [...Friends, ChatUsers(name: name, messageText: messageText, imageURL: imageURL, time: time)]
        });
            },
    );*/

  }
  String _localhostss() {
    if (Platform.isAndroid)
      return 'http://192.168.0.137:7878/getuser';
    else // for iOS simulator
      return 'http://192.168.0.137:7878/getuser';
  }
}
