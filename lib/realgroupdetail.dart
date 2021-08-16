import 'package:flutter/material.dart';
import 'groupchat.dart';
import 'select_group_member.dart';
class GroupList extends StatefulWidget{
  String name;
  String status;
  String id;
  int indexx;
  GroupList({required this.name,required this.status,required this.indexx, required this.id});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<GroupList> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        setState(() {
          print(widget.name);
          print(widget.id);
          Navigator.push(
              context, MaterialPageRoute(
            builder: (context) => ChatPage(id: widget.id, sendid: widget.name,unread: 0,),

          )
          );
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
          color:  Colors.white,
          border:  Border.all(color: Colors.white),
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