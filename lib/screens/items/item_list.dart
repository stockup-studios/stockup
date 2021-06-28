import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockup/business_logic/item/item_viewmodel.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_catalog/product_catalog.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/screens/home/home.dart';
import 'package:stockup/screens/scan/add_files.dart';
import 'package:stockup/screens/search/search.dart';
import 'package:stockup/screens/shopping_list/shop_list.dart';

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

  List<Product> productsList = [
    productCatalog[100],
    productCatalog[200],
    productCatalog[300],
    productCatalog[3000],
  ];

  List<Product> products = [];

  bool allSelected = true;
  Map<ProductCategory, bool> selectedOption = Map.fromIterable(
    ProductCategory.values,
    key: (item) => item,
    value: (item) => false,
  );

  @override
  void initState() {
    super.initState();
    products = productsList;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ItemViewModel>(builder: (context, model, child) {
      return WillPopScope(
        onWillPop: null,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey,
            centerTitle: true,
            title: Center(
              child: Text(title),
            ),
          ),
          body: Container(
            child: Column(
              children: [
                BottomAppBar(
                  shape: CircularNotchedRectangle(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropdownButton<String>(
                          underline: Container(
                            color: Colors.white,
                          ),
                          value: dropdownValue,
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                              if (newValue == 'Shared List') {
                                products = [
                                  productCatalog[150],
                                  productCatalog[250],
                                  productCatalog[350],
                                ];
                              }
                            });
                          },
                          items: <String>['My List', 'Shared List']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        Row(
                          children: [
                            IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  Navigator.pushNamed(context, SearchScreen.id);
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FilterChip(
                            label: Text('All Categories'),
                            selected: allSelected,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedOption = Map.fromIterable(
                                  ProductCategory.values,
                                  key: (item) => item,
                                  value: (item) => false,
                                );
                                allSelected = true;
                                products = productsList;
                              });
                            },
                          ),
                        ),
                      ),
                      for (ProductCategory category in ProductCategory.values)
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: FilterChip(
                              label: Text(
                                  '${category.toString().split('.').last.split('_').join(' ')}'),
                              selected: selectedOption[category],
                              onSelected: (bool selected) {
                                setState(() {
                                  allSelected = false;
                                  selectedOption[category] =
                                      !selectedOption[category];
                                  products = productsList
                                      .where(
                                          (Product p) => p.category == category)
                                      .toList();
                                });
                              },
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 10,
                  child: RefreshIndicator(
                    onRefresh: () {
                      print('refresh triggered');
                    },
                    child: ListView.builder(
                      itemCount: products.length,
                      padding: EdgeInsets.only(top: 5.0),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            setState(() {
                              products.removeAt(index);
                            });
                            if (direction == DismissDirection.startToEnd) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Moved ${product.productName} to shopping list'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Marked ${product.productName} as consumed'),
                                ),
                              );
                            }
                          },
                          background: Container(color: Colors.orange),
                          secondaryBackground: Container(color: Colors.red),
                          child: ListTile(
                            leading: Image.network(products[index].imageURL),
                            title: Text(products[index].productName),
                            subtitle: Text('Expires in ${index + 1} days'),
                            trailing: Icon(Icons.more_vert),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueGrey,
            onPressed: () {
              Navigator.pushNamed(context, AddFilesScreen.id);
            },
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
