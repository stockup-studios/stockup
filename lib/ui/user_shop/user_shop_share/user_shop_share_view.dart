import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/ui/user_shop/user_shop_share/user_shop_share_view_model.dart';

class UserShopShareView extends StatelessWidget {
  const UserShopShareView({@required this.userShopList, Key key})
      : super(key: key);

  final UserShopList userShopList;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserShopShareViewModel>.reactive(
      onModelReady: (model) => model.init(userShopList),
      builder: (context, model, child) => ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 5),
            child: Text(
              'Share list with friends',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      hintText: 'Add by inputting email',
                      border: InputBorder.none),
                  onChanged: (String shareWith) {
                    model.shareWith(shareWith);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: model.sharedUsersEmail.length,
              itemBuilder: (context, index) => FractionallySizedBox(
                widthFactor: 0.9,
                child: Card(
                  child: ListTile(
                    title: Text(
                      model.sharedUsersEmail[index],
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (model.errorMessage != '')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                model.errorMessage,
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
            ),
          FractionallySizedBox(
            widthFactor: 0.7,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text('Share'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: () async {
                  if (await model.share()) Navigator.pop(context);
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
      viewModelBuilder: () => UserShopShareViewModel(),
    );
  }
}