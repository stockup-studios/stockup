import 'package:flutter/material.dart';
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
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text('Pick image from storage'),
                  onPressed: model.addFile,
                ),
                ElevatedButton(
                  child: Text('Pick multiple images from storage'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue.shade700),
                  ),
                  onPressed: model.addFiles,
                ),
                model.isBusy
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
                                  leading: Image.network(model
                                          .productMatches[index].imageURL) ??
                                      Container(color: Colors.black),
                                  title: Text(
                                      model.productMatches[index].productName),
                                  subtitle: Text(model
                                      .productMatches[index].category
                                      .toString()
                                      .split('.')
                                      .last
                                      .split('_')
                                      .join(' ')),
                                  trailing: IconButton(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            UserScanDetailView(
                                                product: model
                                                    .productMatches[index]),
                                      );
                                      model.update();
                                    },
                                    icon: Icon(Icons.edit),
                                  ));
                            }),
                      ),
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
