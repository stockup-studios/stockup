import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  final String title;
  final String desc;

  SummaryTile(this.title, this.desc);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          desc,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        tileColor: Colors.grey.shade400,
      ),
    );
  }
}

final kBottomNavigationBar = BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  showSelectedLabels: false,
  showUnselectedLabels: false,
  items: const <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add_box_outlined),
      label: '',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.format_list_bulleted),
      label: '',
    ),
  ],
  backgroundColor: Colors.grey.shade300,
);
