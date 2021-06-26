import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SuggestionTile extends StatelessWidget {
  final String name;

  SuggestionTile(this.name);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              height: 50,
              width: 50,
              color: Colors.grey,
            ),
            Text(name),
          ],
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String name;
  final String expiry;
  final Widget trailing;

  ProductTile(this.name, this.expiry, this.trailing);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Container(
        color: Colors.white,
        child: ListTile(
          /// replace sized box to render product image
          leading: SizedBox(
            height: 50,
            width: 50,
            child: Container(
              color: Colors.grey,
            ),
          ),
          title: Text(this.name),
          subtitle: Text(this.expiry),
          trailing: this.trailing,
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Archive',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => print('archived'),
        ),
        IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () => print('shared'),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'More',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => print('more'),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => print('delete'),
        ),
      ],
    );
  }
}

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
