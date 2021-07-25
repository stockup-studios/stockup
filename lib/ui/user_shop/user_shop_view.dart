import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';
import 'package:stockup/ui/user_shop/user_shop_add_view.dart';
import 'package:stockup/ui/user_shop/user_shop_detail_view.dart';
import 'package:stockup/ui/user_shop/user_shop_share_view.dart';
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
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) => UserShopShareView(
                              userShopList: model.targetUserShopList,
                            ),
                          );
                          model.update();
                        },
                        icon: Icon(Icons.share),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          UserShop userItem = await showSearch<UserShop>(
                              context: context, delegate: model.search());
                          if (userItem != null)
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) => UserShopDetailView(
                                userShop: userItem,
                              ),
                            );
                          model.update();
                        },
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
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    actions: [
                      IconSlideAction(
                        caption: 'Delete',
                        foregroundColor: Colors.white,
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => model.onDelete(index),
                      )
                    ],
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Bought',
                        foregroundColor: Colors.white,
                        color: Colors.green,
                        icon: Icons.check,
                        onTap: () => model.onMove(index),
                      )
                    ],
                    child: Card(
                      child: ListTile(
                        leading: Image.network(
                          model.displayList[index].imageURL,
                          height: 50,
                          width: 50,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace stackTrace) {
                            return SizedBox(
                              height: 50,
                              width: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                        ),
                        title: Text(model.displayList[index].productName),
                        subtitle:
                            Text(model.displayList[index].quantity.toString()),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) => UserShopDetailView(
                                userShop: model.displayList[index],
                              ),
                            );
                            model.update();
                          },
                        ),
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
            onPressed: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => UserShopAddView(
                  userShopList: model.targetUserShopList,
                ),
              );
              model.update();
            }),
        bottomNavigationBar: BottomNavigation(currentIndex: 3),
      ),
      viewModelBuilder: () => locator<UserShopViewModel>(),
    );
  }
}
