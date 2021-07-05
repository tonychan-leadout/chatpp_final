import 'package:flutter/material.dart';
import 'chat.dart';
class FriendList extends StatefulWidget{
  String name;
  String status;
  String id;
  String sendid;
  FriendList({required this.name,required this.status,required this.sendid, required this.id});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<FriendList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(widget.name);
        Navigator.push(
            context, MaterialPageRoute(
          builder: (context) => ChatPage(id: widget.id,sendid: widget.name,),

        )
        );
      },
      child: Container(
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
                          Text(widget.name, style: TextStyle(fontSize: 16),),
                          SizedBox(height: 6,),
                          Text(widget.status,style: TextStyle(fontSize: 13,color: Colors.grey.shade600, ),)
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
  }
}