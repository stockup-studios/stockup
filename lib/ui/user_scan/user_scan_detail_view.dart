import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';
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
            padding:
                const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 5),
            child: Text(
              'Edit item',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
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
                  onChanged: (newName) {
                    model.name = newName;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    hintText: model.name,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
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
