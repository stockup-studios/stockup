import 'package:flutter/material.dart';

class SummaryTile extends StatelessWidget {
  final String title;
  final String desc;

  SummaryTile(this.title, this.desc);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 40.0,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          desc,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        tileColor: Colors.grey.shade400,
      ),
    );
  }
}
