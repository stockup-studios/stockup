import 'package:flutter/material.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  final String title = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: Center(
          child: Text(
            widget.title,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 5.0),
        children: <SummaryTile>[
          for (int i = 1; i <= 3; ++i)
            SummaryTile('Summary Title $i', 'Description $i')
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
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
      ),
    );
  }
}
