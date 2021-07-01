import 'package:flutter/material.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_item_list.dart';

class UserItemTile extends StatelessWidget {
  const UserItemTile({
    Key key,
    @required this.userItemList,
    @required this.product,
    @required this.index,
  }) : super(key: key);

  final UserItemList userItemList;
  final UserItem product;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        userItemList.delUserItemAtIndex(index);
        if (direction == DismissDirection.startToEnd) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Moved ${product.productName} to shopping list'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Marked ${product.productName} as consumed'),
            ),
          );
        }
      },
      background: Container(color: Colors.orange),
      secondaryBackground: Container(color: Colors.red),
      child: ListTile(
        leading: Image.network(product.imageURL),
        title: Text(product.productName),
        subtitle: Text('Expires in ${index + 1} days'),
        trailing: Icon(Icons.more_vert),
      ),
    );
  }
}
