import 'package:flutter/material.dart';
import '../constants.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'search_screen';
  final String title = 'Search Items';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            widget.title,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: TextField(
              autocorrect: false,
              decoration: InputDecoration(
                  prefix: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  labelText: 'Search Items'),
            ),
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(top: 5.0),
              children: [
                for (int i = 1; i <= 10; ++i)
                  ProductTile(
                    'Product $i',
                    'Expires in $i',
                    Icon(Icons.more_vert),
                  )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: kBottomNavigationBar,
    );
  }
}
