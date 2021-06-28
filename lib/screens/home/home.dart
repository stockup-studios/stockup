import 'package:flutter/material.dart';
import 'package:stockup/screens/welcome/welcome.dart';
import 'package:stockup/services/auth/auth_impl.dart';
import 'package:stockup/screens/items/item_list.dart';
import 'package:stockup/screens/scan/add_files.dart';
import 'package:stockup/screens/shopping_list/shop_list.dart';
import 'package:fl_chart/fl_chart.dart';
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
    final AuthImplementation _auth = AuthImplementation();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: Center(
          child: Text(
            widget.title,
          ),
        ),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
              Navigator.pushNamed(context, WelcomeScreen.id);
            },
          )
        ],
      ),
      body: ListView(padding: EdgeInsets.only(top: 5.0), children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.only(top: 10, right: 15, bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red.shade300,
                Colors.redAccent,
              ],
            ),
          ),
          child: ListTile(
            title: Text(
              '1 Item Expired',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Yesterday | Marigold HL Milk',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.only(top: 10, right: 15, bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orangeAccent,
                Colors.deepOrangeAccent,
              ],
            ),
          ),
          child: ListTile(
            title: Text(
              '2 Items Expiring Soon',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2 days | Golden Churn Butter Block - Salted',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  '3 days | UFC Refresh 100% Natural Coconut Water',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          padding: EdgeInsets.only(top: 10, right: 15, bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade200,
                Colors.indigo,
              ],
            ),
          ),
          child: ListTile(
            title: Text(
              '1 Shared List',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 40,
                color: Colors.white,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Click to view',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]
          //children: <SummaryTile>[
          //for (int i = 1; i <= 3; ++i)
          // SummaryTile('Summary Title $i', 'Description $i')
          //],
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
