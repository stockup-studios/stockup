import 'package:flutter/material.dart';

class AddReceiptScreen extends StatefulWidget {
  static const String id = 'add_receipt_screen';
  final String title = 'Add Receipt';

  @override
  _AddReceiptScreenState createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
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
      // bottomNavigationBar: kBottomNavigationBar,
    );
  }
}
