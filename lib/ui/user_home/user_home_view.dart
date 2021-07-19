import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/ui/components/bottom_navigation/bottom_navigation.dart';
import 'package:stockup/ui/user_home/user_home_view_model.dart';

class UserHomeView extends StatelessWidget {
  const UserHomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserHomeViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      onModelReady: (model) => model.init(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person, color: Colors.white,),
              label: Text('Logout'),
              onPressed: () async {
                model.signOut();
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: model.messages.length,
          itemBuilder: (context, index) {
            return HomeTile(
              // TODO: Replace with service
              colorLeft: Colors.orangeAccent,
              colorRight: Colors.deepOrangeAccent,
              text: model.messages[index],
            );
          },
        ),
        bottomNavigationBar: BottomNavigation(currentIndex: 0),
      ),
      viewModelBuilder: () => UserHomeViewModel(),
    );
  }
}

class HomeTile extends StatelessWidget {
  final colorLeft;
  final colorRight;
  final List<String> text;

  const HomeTile({
    Key key,
    @required this.colorLeft,
    @required this.colorRight,
    @required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.only(top: 10, right: 15, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorLeft,
              colorRight,
            ],
          ),
        ),
        child: ListTile(
          title: Text(
            text[0],
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 40,
              color: Colors.white,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String detail in text.sublist(1))
                Text(
                  detail,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
