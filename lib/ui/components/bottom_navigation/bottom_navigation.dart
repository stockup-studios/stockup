import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/ui/user_home/user_home_view.dart';
import 'package:stockup/ui/user_item/user_item_list/user_item_view.dart';
import 'package:stockup/ui/user_scan/user_scan_view.dart';
import 'package:stockup/ui/user_shop/user_shop_list/user_shop_view.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final _navigationService = locator<NavigationService>();
  BottomNavigation({@required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    void _onBottomNavigationBarItemTapped(int index) {
      if (index == currentIndex) return;
      switch (index) {
        case UserHomeView.index:
          _navigationService.replaceWith(Routes.userHomeView);
          break;
        case UserItemView.index:
          _navigationService.replaceWith(Routes.userItemView);
          break;
        case UserScanView.index:
          _navigationService.replaceWith(Routes.userScanView);
          break;
        case UserShopView.index:
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
