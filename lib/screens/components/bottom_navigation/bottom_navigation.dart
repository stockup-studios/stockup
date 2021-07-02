import 'package:flutter/material.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/items/item_list.dart';
import 'package:stockup/screens/scan/add_files.dart';
import 'package:stockup/screens/shopping_list/shop_list.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  BottomNavigation({@required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    void _onBottomNavigationBarItemTapped(int index) {
      if (index == currentIndex) return;
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

    return BottomNavigationBar(
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
      currentIndex: currentIndex,
      onTap: _onBottomNavigationBarItemTapped,
    );
  }
}
