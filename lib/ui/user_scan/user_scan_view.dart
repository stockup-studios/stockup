import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';
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
                  onPressed:
                      () {}, // TODO: Implement single scanning functionality as service in ViewModel
                ),
                ElevatedButton(
                  child: Text('Pick multiple images from storage'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue.shade700),
                  ),
                  onPressed:
                      () {}, // TODO: Implement multi scanning functionality as service in ViewModel
                ),
                Expanded(
                  child: Container(), // TODO: Implement view scan results
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
