import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/items/item_list.dart';
import 'package:stockup/screens/scan/add_files.dart';
import 'package:stockup/screens/shopping_list/shop_list.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final _navigationService = locator<NavigationService>();
  BottomNavigation({@required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    void _onBottomNavigationBarItemTapped(int index) {
      if (index == currentIndex) return;
      switch (index) {
        case HomeScreen.index:
          _navigationService.replaceWith(Routes.userHomeView);
          break;
        case ItemListScreen.index:
          _navigationService.replaceWith(Routes.userItemView);
          break;
        case AddFilesScreen.index:
          _navigationService.replaceWith(Routes.userScanView);
          break;
        case ShopListScreen.index:
          _navigationService.replaceWith(Routes.userShopView);
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
