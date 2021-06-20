import 'package:flutter/material.dart';
import '../constants.dart';

class AddFilesScreen extends StatefulWidget {
  static const String id = 'add_files_screen';
  final String title = 'Add Files';

  @override
  _AddFilesScreenState createState() => _AddFilesScreenState();
}

class _AddFilesScreenState extends State<AddFilesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade400,
        title: Center(
          child: Text(
            widget.title,
          ),
        ),
      ),
      // TODO: Replace container with camera widget
      body: Container(
        color: Colors.grey.shade200,
      ),
      // TODO: Use BottomSheet to display search results
      bottomNavigationBar: kBottomNavigationBar,
    );
  }
}
