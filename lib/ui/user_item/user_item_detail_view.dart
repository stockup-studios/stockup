import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/ui/user_item/user_item_detail_view_model.dart';

class UserItemDetailView extends StatelessWidget {
  const UserItemDetailView({
    @required this.userItem,
    Key key,
  }) : super(key: key);
  final UserItem userItem;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserItemDetailViewModel>.reactive(
      onModelReady: (model) => model.init(userItem),
      builder: (context, model, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Text('Name'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      onChanged: (newName) {
                        model.name = newName;
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: model.userItem.productName,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Category'),
              ),
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<ProductCategory>(
                  value: model.category,
                  icon: Icon(Icons.arrow_downward),
                  onChanged: (ProductCategory newCategory) {
                    model.category = newCategory;
                  },
                  items: ProductCategory.values
                      .map<DropdownMenuItem<ProductCategory>>(
                          (ProductCategory category) {
                    return DropdownMenuItem<ProductCategory>(
                      child: Text(category.name),
                      value: category,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Expires on'),
              ),
              TextButton(
                onPressed: () => model.changeExpiry(context),
                child: Row(
                  children: [
                    Container(
                      child:
                          Text(DateFormat('dd MMM yyyy').format(model.expiry)),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ],
          ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Save'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: () {
                  model.save();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
          ),
        ],
      ),
      viewModelBuilder: () => UserItemDetailViewModel(),
    );
  }
}
