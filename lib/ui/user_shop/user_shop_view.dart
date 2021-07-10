import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';
import 'package:stockup/ui/user_shop/user_shop_view_model.dart';

class UserShopView extends StatelessWidget {
  const UserShopView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserShopViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.init(),
      fireOnModelReadyOnce: true,
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
                        onPressed: () => showSearch(
                            context: context, delegate: model.search()),
                      ),
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
                      selected: model.productCategories.values.toList()[index],
                      onSelected: (e) {
                        model.filter(index);
                      },
                      label: Text(model.productCategories.keys.toList()[index]),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 10,
              child: ListView.builder(
                itemCount: model.displayList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text(model.displayList[index].productName),
                      subtitle:
                          Text(model.displayList[index].quantity.toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () => model.move(index),
                      ),
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
      viewModelBuilder: () => locator<UserShopViewModel>(),
    );
  }
}