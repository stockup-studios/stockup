import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockup/business_logic/item/item_viewmodel.dart';
import '../constants.dart';

class ItemsScreen extends StatefulWidget {
  static const String id = 'items_screen';
  final String title = 'Items';

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final int noCategories = 6;
  final String title = 'Items';
  String dropdownValue = 'My List';

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
          bottomNavigationBar: kBottomNavigationBar,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
        ),
      );
    });
  }
}
