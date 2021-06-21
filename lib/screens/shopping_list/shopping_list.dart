import 'package:flutter/material.dart';
import '../constants.dart';

class ShoppingListScreen extends StatefulWidget {
  static const String id = 'shopping_list_screen';
  final String title = 'Shopping List';

  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final int noSuggestions = 6;
  final String title = 'Shopping List';
  String dropdownValue = 'My List';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
          child: Text(title),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.sort_rounded),
                  DropdownButton<String>(
                    value: dropdownValue,
                    elevation: 16,
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['My List', 'One', 'Two', 'Free', 'Four']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Icon(Icons.share),
                  Icon(Icons.sort_by_alpha),
                  Icon(Icons.search),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  for (int i = 0; i < noSuggestions; ++i)
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: FilterChip(
                        label: Text('Category $i'),
                        selected: false,
                        onSelected: (bool selected) {},
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(top: 5.0),
                children: [
                  Container(
                    color: Colors.grey.shade300,
                    height: 150,
                    margin: EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: Text('Suggestions'),
                          margin: EdgeInsets.all(5),
                        ),
                        Expanded(
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (int i = 0; i < noSuggestions; ++i)
                                SuggestionTile('Suggestion $i'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
      ),
      bottomNavigationBar: kBottomNavigationBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
