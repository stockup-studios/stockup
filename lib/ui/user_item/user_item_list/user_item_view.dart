import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';
import 'package:stockup/ui/user_item/user_item_share_view.dart';
import 'package:stockup/ui/user_item/user_item_detail/user_item_detail_view.dart';
import 'package:stockup/ui/user_item/user_item_list/user_item_view_model.dart';

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
                        onPressed: () async {
                          await showModalBottomSheet(
                            context: context,
                            builder: (context) => UserItemShareView(
                              userItemList: model.targetUserItemList,
                            ),
                          );
                          model.update();
                        },
                        icon: Icon(Icons.share),
                      ),
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          UserItem userItem = await showSearch<UserItem>(
                              context: context, delegate: model.search());
                          if (userItem != null)
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) => UserItemDetailView(
                                userItem: userItem,
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
                  // return UserItemTile(model: model, index: index);
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    actions: [
                      IconSlideAction(
                        caption: 'Move',
                        foregroundColor: Colors.white,
                        color: Colors.orange,
                        icon: Icons.list,
                        onTap: () => model.onMove(index),
                      )
                    ],
                    secondaryActions: [
                      IconSlideAction(
                        caption: 'Consume',
                        foregroundColor: Colors.white,
                        color: Colors.green,
                        icon: Icons.check,
                        onTap: () => model.onConsume(index),
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
                        subtitle: model.displayList[index].daysLeft == 1
                            ? Text(
                                '${model.displayList[index].daysLeft} day left')
                            : Text(
                                '${model.displayList[index].daysLeft} days left'),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            await showModalBottomSheet(
                              context: context,
                              builder: (context) => UserItemDetailView(
                                userItem: model.displayList[index],
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
          onPressed: model.add,
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 1),
      ),
      viewModelBuilder: () => locator<UserItemViewModel>(),
    );
  }
}
