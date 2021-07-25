import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';
import 'package:stockup/ui/user_scan/user_scan_detail_view.dart';
import 'package:stockup/ui/user_scan/user_scan_view_model.dart';

class UserScanView extends StatelessWidget {
  const UserScanView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserScanViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Center(
            child: Text('Scan'),
          ),
        ),
        body: Container(
          color: Colors.grey.shade200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: IconButton(
                              onPressed: model.addFile,
                              icon: Icon(
                                Icons.insert_drive_file,
                                color: Colors.grey.shade400,
                              ),
                              iconSize: 72,
                            ),
                            subtitle: Text(
                              'Single scan',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: IconButton(
                              onPressed: model.addFiles,
                              icon: Icon(
                                Icons.file_copy_sharp,
                                color: Colors.grey.shade600,
                              ),
                              iconSize: 72,
                            ),
                            subtitle: Text(
                              'Bulk Scan',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // ElevatedButton(
                //   style: ButtonStyle(
                //     backgroundColor:
                //         MaterialStateProperty.all<Color>(Colors.blue),
                //   ),
                //   child: Text('Pick image from storage'),
                //   onPressed: model.addFile,
                // ),
                // ElevatedButton(
                //   child: Text('Pick multiple images from storage'),
                //   style: ButtonStyle(
                //     backgroundColor:
                //         MaterialStateProperty.all<Color>(Colors.blue.shade700),
                //   ),
                //   onPressed: model.addFiles,
                // ),
                Container(
                  child: model.isBusy
                      ? Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              padding: const EdgeInsets.all(8),
                              itemCount: model.productMatches.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) =>
                                            UserScanDetailView(
                                                product: model
                                                    .productMatches[index]),
                                      );
                                      model.update();
                                    },
                                    leading: Image.network(model
                                            .productMatches[index].imageURL) ??
                                        Container(color: Colors.black),
                                    title: Text(model
                                        .productMatches[index].productName),
                                    subtitle: Text(
                                        'Expires on ${DateFormat('dd MMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(model.productMatches[index].expiryDate))}'),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            model.duplicate(index);
                                          },
                                          icon: Icon(Icons.add_to_photos),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            model.delete(index);
                                          },
                                          icon: Icon(Icons.delete),
                                        )
                                      ],
                                    ));
                              }),
                        ),
                ),
                if (model.foundNoTextError != '')
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      model.foundNoTextError,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text('Add to item list'),
                    style: ButtonStyle(
                      backgroundColor:
                          (!model.isBusy && model.productMatches.length > 0)
                              ? MaterialStateProperty.all<Color>(Colors.green)
                              : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                    onPressed:
                        (!model.isBusy && model.productMatches.length > 0)
                            ? model.addToItems
                            : model.noItems,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 2),
      ),
      viewModelBuilder: () => UserScanViewModel(),
    );
  }
}
