import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/ui/user_item/user_item_add/user_item_add_view_model.dart';

class UserItemAddView extends StatelessWidget {
  const UserItemAddView({@required this.userItemList, Key key})
      : super(key: key);

  final UserItemList userItemList;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserItemAddViewModel>.reactive(
      onModelReady: (model) => model.init(userItemList),
      builder: (context, model, child) => ListView(
        //mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 5),
            child: Text(
              'Add New Item',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Item name',
                      border: InputBorder.none),
                  onChanged: (String name) {
                    model.name = name;
                  },
                ),
              ),
            ),
          ),
          if (model.nameError != '')
            Text(
              model.nameError,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Item Image URL (leave blank for default)',
                      border: InputBorder.none),
                  onChanged: (String imageURL) {
                    model.imageURL = imageURL;
                  },
                ),
              ),
            ),
          ),
          if (model.imageError != '')
            Text(
              model.imageError,
              style: TextStyle(color: Colors.red),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: DropdownButton<ProductCategory>(
                isExpanded: true,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: TextButton(
                onPressed: () async {
                  final DateTime newDate = await showDatePicker(
                    context: context,
                    initialDate: model.expiry,
                    // DateTime.fromMillisecondsSinceEpoch(
                    //     model.displayList[index].expiryDate),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 1),
                  );
                  if (newDate != null) model.expiry = newDate;
                },
                child: Row(
                  children: [
                    Container(
                      child: Text(
                          'Expires on ${DateFormat('dd MMM yyyy').format(model.expiry)}'),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
          ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ElevatedButton(
                    child: Text('Add Item'),
                    style: ButtonStyle(
                      backgroundColor: model.name == ''
                          ? MaterialStateProperty.all<Color>(Colors.grey)
                          : MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    onPressed: () async {
                      if (await model.add()) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
          ),
        ],
      ),
      viewModelBuilder: () => UserItemAddViewModel(),
    );
  }
}
