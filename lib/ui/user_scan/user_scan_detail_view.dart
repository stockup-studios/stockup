import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/ui/user_scan/user_scan_detail_view_model.dart';

class UserScanDetailView extends StatelessWidget {
  const UserScanDetailView({
    @required this.product,
    Key key,
  }) : super(key: key);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserScanDetailViewModel>.reactive(
      onModelReady: (model) => model.init(product),
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
                        hintText: model.name,
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
      viewModelBuilder: () => UserScanDetailViewModel(),
    );
  }
}
