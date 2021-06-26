import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockup/business_logic/item/item_viewmodel.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/scan/add_files.dart';
import 'package:stockup/screens/shopping_list/shop_list.dart';
import '../constants.dart';

class ItemListScreen extends StatefulWidget {
  static const String id = 'items_screen';
  static const int index = 1;
  final String title = 'Items';

  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final int noCategories = 6;
  final String title = 'Items';
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
    return Consumer<ItemViewModel>(builder: (context, model, child) {
      return WillPopScope(
        onWillPop: null,
        child: Scaffold(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              child: Icon(Icons.sort_rounded),
                              padding: EdgeInsets.all(10),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: DropdownButton<String>(
                                value: dropdownValue,
                                elevation: 16,
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: <String>[
                                  'My List',
                                  'One',
                                  'Two',
                                  'Free',
                                  'Four'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.share),
                            Icon(Icons.sort_by_alpha),
                            Icon(Icons.search),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (int i = 0; i < noCategories; ++i)
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
                  child: RefreshIndicator(
                    onRefresh: () {
                      print('refresh triggered');
                    },
                    child: ListView(
                      padding: EdgeInsets.only(top: 5.0),
                      children: [
                        for (int i = 1; i <= 3; ++i)
                          ProductTile(
                            'Product $i',
                            'Expires in $i',
                            Icon(Icons.more_vert),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
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
            currentIndex: ItemListScreen.index,
            onTap: _onBottomNavigationBarItemTapped,
          ),
        ),
      );
    });
  }
}
