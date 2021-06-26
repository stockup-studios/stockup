import 'package:flutter/material.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/items/item_list.dart';
import 'package:stockup/screens/scan/add_files.dart';
import '../constants.dart';

class ShopListScreen extends StatefulWidget {
  static const String id = 'shopping_list_screen';
  static const int index = 3;
  final String title = 'Shopping List';

  @override
  _ShopListScreenState createState() => _ShopListScreenState();
}

class _ShopListScreenState extends State<ShopListScreen> {
  final int noSuggestions = 6;
  final String title = 'Shopping List';
  String dropdownValue = 'My List';

  void _onBottomNavigationBarItemTapped(int index) {
    switch (index) {
      case HomeScreen.index:
        Navigator.of(context).pushReplacementNamed(HomeScreen.id);
        break;
      case ItemListScreen.index:
        Navigator.of(context).pushReplacementNamed(ItemListScreen.id);
        break;
      case AddFilesScreen.index:
        Navigator.of(context).pushReplacementNamed(AddFilesScreen.id);
        break;
      case ShopListScreen.index:
        Navigator.of(context).pushReplacementNamed(ShopListScreen.id);
        break;
      default:
        print('_onBottomNavigationBarItemTapped navigation error');
        break;
    }
  }

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
      // bottomNavigationBar: kBottomNavigationBar,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
        currentIndex: ShopListScreen.index,
        onTap: _onBottomNavigationBarItemTapped,
      ),
    );
  }
}
