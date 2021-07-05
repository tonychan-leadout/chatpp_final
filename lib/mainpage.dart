import 'package:flutter/material.dart';
import 'conversation.dart';
import 'friend.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'profile.dart';
class content extends StatefulWidget {
  @override
  content({ required this.id,required this.sendid, required this.status}) ;
  final String id;
  final String sendid;
  final String status;
  _contentState createState() => _contentState();
}

class _contentState extends State<content> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions() =>[
    ChatPage(id: widget.id),
    Friend(id: widget.id,sendid: widget.sendid,),
    Profile(name: widget.id,status:widget.status),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    print(widget.id);
  }
  @override
  Widget build(BuildContext context) {
    final  List<Widget> widdget = _widgetOptions();
    return Scaffold(
      body: widdget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
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