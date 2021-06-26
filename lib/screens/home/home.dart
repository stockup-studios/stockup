import 'package:flutter/material.dart';
import 'package:stockup/screens/items/item_list.dart';
import 'package:stockup/screens/scan/add_files.dart';
import 'package:stockup/screens/shopping_list/shop_list.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  static const int index = 0;
  final String title = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        currentIndex: HomeScreen.index,
        onTap: _onBottomNavigationBarItemTapped,
      ),
    );
  }
}
