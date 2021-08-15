import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/ui/user_shop/user_shop_detail/user_shop_detail_view_model.dart';

class UserShopDetailView extends StatelessWidget {
  const UserShopDetailView({
    @required this.userShop,
    @required this.userShopList,
    Key key,
  }) : super(key: key);
  final UserShop userShop;
  final UserShopList userShopList;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserShopDetailViewModel>.reactive(
      onModelReady: (model) => model.init(userShop, userShopList),
      builder: (context, model, child) => ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text('Name'),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: TextField(
                      enabled: false,
                      onChanged: (newName) {
                        model.name = newName;
                      },
                      decoration: InputDecoration.collapsed(
                        hintText: model.userShop.productName,
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Category'),
              ),
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text('Quantity'),
              ),
              IconButton(
                onPressed: model.delQuantity,
                icon: Icon(Icons.exposure_minus_1),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
        ],
      ),
      viewModelBuilder: () => UserShopDetailViewModel(),
    );
  }
}
