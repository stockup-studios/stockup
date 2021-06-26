import 'package:flutter/material.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_catalog/product_catalog.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/items/item_list.dart';
import 'package:stockup/screens/shopping_list/shop_list.dart';
import 'package:stockup/services/parser/parser.dart';
import 'package:stockup/services/scanner/scanner.dart';

class AddFilesScreen extends StatefulWidget {
  static const String id = 'add_files_screen';
  static const int index = 2;
  final String title = 'Add Files';

  @override
  _AddFilesScreenState createState() => _AddFilesScreenState();
}

class _AddFilesScreenState extends State<AddFilesScreen> {
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

  List<Product> productsFound = [];

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
      body: Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Pick image from storage'),
                onPressed: () async {
                  String imageFile = await Scanner.getImageFilePath();
                  List<String> text =
                      await Scanner.getTextFromImageFile(imageFile);
                  List<String> matches = Parser.getBestMatches(text);
                  List<Product> productMatches = [];
                  for (String match in matches) {
                    print(match);
                    Product p = productCatalog
                        .firstWhere((product) => product.productName == match);
                    productMatches.add(p);
                  }
                  matches.forEach((String productName) {
                    productCatalog.firstWhere(
                        (product) => product.productName == productName);
                  });
                  setState(() {
                    productsFound.addAll(productMatches);
                  });
                },
              ),
              ElevatedButton(
                child: Text('Pick multiple images from storage'),
                onPressed: () async {
                  String imageFile = await Scanner.getImageFilePath();
                  List<String> text =
                      await Scanner.getTextFromImageFile(imageFile);
                  List<String> matches = Parser.getBestMatches(text);
                  List<Product> productMatches = [];
                  for (String match in matches) {
                    print(match);
                    Product p = productCatalog
                        .firstWhere((product) => product.productName == match);
                    productMatches.add(p);
                  }
                  matches.forEach((String productName) {
                    productCatalog.firstWhere(
                        (product) => product.productName == productName);
                  });
                  setState(() {
                    productsFound.addAll(productMatches);
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: productsFound.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: Text('${productsFound[index].productName}'),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
      // TODO: Use BottomSheet to display search results
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
        currentIndex: AddFilesScreen.index,
        onTap: _onBottomNavigationBarItemTapped,
      ),
    );
  }
}
