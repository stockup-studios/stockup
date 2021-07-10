import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';
import 'package:stockup/ui/user_item/user_item_view_model.dart';

class UserItemView extends StatelessWidget {
  const UserItemView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserItemViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.init(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Items'),
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
                    child: DropdownButton<UserItemList>(
                      value: model.targetUserItemList,
                      icon: Icon(Icons.arrow_downward),
                      onChanged: (UserItemList newList) {
                        model.targetUserItemList = newList;
                      },
                      items: model.userItemLists
                          .map<DropdownMenuItem<UserItemList>>(
                              (UserItemList uil) {
                        return DropdownMenuItem<UserItemList>(
                          child: Text(uil.name),
                          value: uil,
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
                          Text(model.displayList[index].expiryDate.toString()),
                      trailing: IconButton(
                        icon: Icon(Icons.add_to_photos),
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
          onPressed: model.add,
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 1),
      ),
      viewModelBuilder: () => locator<UserItemViewModel>(),
    );
  }
}
