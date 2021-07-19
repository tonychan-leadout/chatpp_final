import 'package:flutter/material.dart';
import 'conversation.dart';
import 'group.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'profile.dart';
class content extends StatefulWidget {
  @override
  content({ required this.id,required this.status,required this.indexx}) ;
  final String id;
  final String status;
   int indexx;
  _contentState createState() => _contentState();
}

class _contentState extends State<content> {
  List<Widget> _widgetOptions() =>[
    New(id: widget.id),
    Friend(id: widget.id),
    Profile(name: widget.id,status:widget.status),
  ];
  void _onItemTapped(int index) {
    setState(() {
      widget.indexx = index;
    });
    print(widget.id);
  }
  @override
  Widget build(BuildContext context) {
    final  List<Widget> widdget = _widgetOptions();
    return Scaffold(
      body: widdget.elementAt(widget.indexx),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        currentIndex: widget.indexx,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text("Chats"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt),
            title: Text("Friends"),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}