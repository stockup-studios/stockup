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

// class UserItemTile extends StatelessWidget {
//   const UserItemTile({
//     @required this.model,
//     @required this.index,
//     Key key,
//   }) : super(key: key);
//
//   final model;
//   final int index;
//
//   @override
//   Widget build(BuildContext context) {
//     return Dismissible(
//       key: UniqueKey(),
//       onDismissed: (direction) => model.onSwipe(direction, index),
//       background: Container(color: Colors.orange),
//       secondaryBackground: Container(color: Colors.red),
//       child: Card(
//         child: ListTile(
//           leading: Image.network(
//             model.displayList[index].imageURL,
//             height: 50,
//             width: 50,
//             errorBuilder: (BuildContext context, Object exception,
//                 StackTrace stackTrace) {
//               return SizedBox(
//                 height: 50,
//                 width: 50,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             },
//           ),
//           title: Text(model.displayList[index].productName),
//           subtitle: model.displayList[index].daysLeft == '1'
//               ? Text('${model.displayList[index].daysLeft} day left')
//               : Text('${model.displayList[index].daysLeft} days left'),
//           trailing: IconButton(
//             icon: Icon(Icons.edit),
//             onPressed: () {
//               model.editProductName = model.displayList[index].productName;
//               model.editProductCategory = model.displayList[index].category;
//               model.editExpiryDate = DateTime.fromMillisecondsSinceEpoch(
//                   model.displayList[index].expiryDate);
//               showBottomSheet(
//                 context: context,
//                 builder: (context) => Container(
//                   height: 350,
//                   // margin: const EdgeInsets.only(top: 35),
//                   color: Colors.grey[100],
//                   child: Column(
//                     // mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                             child: Container(
//                               alignment: Alignment.center,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               child: Text('Name'),
//                             ),
//                           ),
//                           Expanded(
//                             flex: 3,
//                             child: Container(
//                               alignment: Alignment.center,
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               margin: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 10),
//                               decoration: BoxDecoration(
//                                   color: Colors.grey[300],
//                                   borderRadius: BorderRadius.circular(10)),
//                               child: TextField(
//                                 onChanged: (newName) =>
//                                     model.editName(index, newName),
//                                 decoration: InputDecoration.collapsed(
//                                   hintText:
//                                       model.displayList[index].productName,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Container(
//                             alignment: Alignment.center,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             child: Text('Category'),
//                           ),
//                           Container(
//                             alignment: Alignment.center,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             child: DropdownButton<ProductCategory>(
//                               value: model.editProductCategory,
//                               icon: Icon(Icons.arrow_downward),
//                               onChanged: (ProductCategory newCategory) {
//                                 model.editCategory(index, newCategory);
//                                 model.editProductCategory = newCategory;
//                               },
//                               items: ProductCategory.values
//                                   .map<DropdownMenuItem<ProductCategory>>(
//                                       (ProductCategory category) {
//                                 return DropdownMenuItem<ProductCategory>(
//                                   child: Text(category.name),
//                                   value: category,
//                                 );
//                               }).toList(),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Container(
//                             alignment: Alignment.center,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             child: Text('Expiry Date'),
//                           ),
//                           Container(
//                             child: Text(DateFormat('dd MMM yyyy').format(
//                                 DateTime.fromMillisecondsSinceEpoch(
//                                     model.displayList[index].expiryDate))),
//                           ),
//                           Container(
//                             alignment: Alignment.center,
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 10),
//                             child: ElevatedButton(
//                               child: Text('Change Date'),
//                               onPressed: () async {
//                                 final DateTime picked = await showDatePicker(
//                                   context: context,
//                                   initialDate:
//                                       DateTime.fromMillisecondsSinceEpoch(
//                                           model.displayList[index].expiryDate),
//                                   firstDate: DateTime.now(),
//                                   lastDate: DateTime(2022),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ElevatedButton(
//                           child: Text('Save'),
//                           style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStateProperty.all<Color>(Colors.green),
//                           ),
//                           onPressed: () {
//                             model.editSave(index);
//                             Navigator.pop(context);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
