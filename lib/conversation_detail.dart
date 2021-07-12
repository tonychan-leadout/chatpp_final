
import 'package:flutter/material.dart';
import 'chat.dart';
class ConversationList extends StatefulWidget{
  String id;
  String name;
  String messageText;
  int imageUrl;
  String time;
  bool isMessageRead;
  ConversationList({required this.id,required this.name,required this.messageText,required this.imageUrl,required this.time,required this.isMessageRead});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(widget.name);
        Navigator.push(
            context, MaterialPageRoute(
          builder: (context) => ChatPage(id: widget.id, sendid: widget.name,),

        )
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Column(
                    children: [

                      CircleAvatar(
                        backgroundImage: ExactAssetImage('images/user.png'),
                        maxRadius: 30,
                      ),
                    ],
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
                          Text(widget.messageText, style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                              fontWeight: widget.isMessageRead
                                  ? FontWeight.bold
                                  : FontWeight.normal),),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(widget.time, style: TextStyle(fontSize: 12,
                    fontWeight: widget.imageUrl >0 ? FontWeight.bold : FontWeight
                        .normal),),
                SizedBox(
                  height: 10,
                ),
                if(widget.imageUrl >0)
                Container(
                  padding: EdgeInsets.only(left: 8,right: 8,top: 2,bottom: 2),
                  height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.greenAccent,
                  ),
                  child: Text(widget.imageUrl.toString(), style: TextStyle(fontSize: 12,
                      fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight
                          .normal),),
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}
