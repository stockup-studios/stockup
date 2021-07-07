import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/screens/components/bottom_navigation/bottom_navigation.dart';
import 'package:stockup/ui/user_shop/user_shop_view_model.dart';

class UserShopView extends StatelessWidget {
  const UserShopView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserShopViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Shopping Lists'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            BottomAppBar(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<UserShopList>(
                      value: model.targetUserShopList,
                      icon: Icon(Icons.arrow_downward),
                      onChanged: (UserShopList newList) {
                        model.targetUserShopList = newList;
                      },
                      items: model.userShopLists
                          .map<DropdownMenuItem<UserShopList>>(
                              (UserShopList usl) {
                        return DropdownMenuItem<UserShopList>(
                          child: Text(usl.name),
                          value: usl,
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {},
                      ) // TODO: Implement search functionality
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: model.productCategories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilterChip(
                      onSelected: (e) {}, // TODO: Implement filter in ViewModel
                      label: Text(model.productCategories[index]),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 10,
              child: ListView.builder(
                itemCount: model.targetUserShopList.userShopListing.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text(model.targetUserShopList
                          .userShopListing[index].productName),
                      subtitle: Text(model
                          .targetUserShopList.userShopListing[index].quantity
                          .toString()),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: model
              .add, // TODO: Implement adding functionality with service in ViewModel
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 3),
      ),
      viewModelBuilder: () => UserShopViewModel(),
    );
  }
}
