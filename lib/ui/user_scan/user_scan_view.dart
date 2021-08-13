import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';
import 'package:stockup/ui/user_scan/user_scan_detail_view.dart';
import 'package:stockup/ui/user_scan/user_scan_view_model.dart';

class UserScanView extends StatelessWidget {
  static const int index = 2;
  const UserScanView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserScanViewModel>.reactive(
      disposeViewModel: false,
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
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
                // Card(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Text(
                //               'Single Scan',
                //               textScaleFactor: 2,
                //               style: TextStyle(
                //                 fontWeight: FontWeight.w500,
                //               ),
                //             ),
                //             Text('Scan a single receipt'),
                //             OutlinedButton(
                //                 onPressed: () {}, child: Text('Scan'))
                //           ],
                //         ),
                //       ),
                //       Icon(
                //         Icons.insert_drive_file,
                //         color: Colors.grey.shade400,
                //         size: 72,
                //       )
                //     ],
                //   ),
                // ),
                if (model.productMatches.length == 0 && !model.isBusy)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Let\'s scan some receipts!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.orangeAccent.shade100,
                                    ),
                                  ),
                                  onPressed: model.addFile,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Icon(
                                        Icons.insert_drive_file,
                                        size: 72,
                                        color: Colors.orangeAccent.shade100,
                                      ),
                                      subtitle: Text(
                                        'Scan Single Receipt',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.deepOrangeAccent.shade100,
                                    ),
                                  ),
                                  onPressed: model.addFiles,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      title: Icon(
                                        Icons.file_copy_sharp,
                                        size: 72,
                                        color: Colors.deepOrangeAccent.shade100,
                                      ),
                                      subtitle: Text(
                                        'Scan Multiple Receipts',
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                if (model.productMatches.length > 0 || model.isBusy)
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
                                              .productMatches[index]
                                              .imageURL) ??
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
                if (model.productMatches.length > 0)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Container(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.file_copy_sharp),
                                    Text('Scan Another'),
                                  ],
                                ),
                              ),
                              onPressed: model.addFile,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.grey),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: Container(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.check),
                                    Text('Add Items'),
                                  ],
                                ),
                              ),
                              onPressed: model.addToItems,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                              ),
                            ),
                          ),
                        ),
                      ],
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
