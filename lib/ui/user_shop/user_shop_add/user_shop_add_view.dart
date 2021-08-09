import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/ui/user_shop/user_shop_add/user_shop_add_view_model.dart';

class UserShopAddView extends StatelessWidget {
  const UserShopAddView({@required this.userShopList, Key key})
      : super(key: key);

  final UserShopList userShopList;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserShopAddViewModel>.reactive(
      onModelReady: (model) => model.init(userShopList),
      builder: (context, model, child) => ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 5),
            child: Text(
              'Add Item To Buy',
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
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
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
              textAlign: TextAlign.center,
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
                child: Row(
                  children: [
                    IconButton(
                      onPressed: model.delQuantity,
                      icon: Icon(Icons.exposure_minus_1),
                    ),
                    // Text(model.quantity.toString()),
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
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.phone,
                          onChanged: (newVal) {
                            model.changeQuantity(newVal);
                          },
                          decoration: InputDecoration.collapsed(
                            hintText: model.quantity.toString(),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: model.addQuantity,
                      icon: Icon(Icons.exposure_plus_1),
                    ),
                  ],
                )),
          ),
          if (model.quantityError != '')
            Text(
              model.quantityError,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
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
          // Padding(
          //   padding: EdgeInsets.only(
          //       bottom: MediaQuery.of(context).viewInsets.bottom),
          // ),
        ],
      ),
      viewModelBuilder: () => UserShopAddViewModel(),
    );
  }
}
