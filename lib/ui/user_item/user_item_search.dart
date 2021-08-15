import 'package:flutter/material.dart';
import 'package:stockup/models/models.dart';

class UserItemSearch extends SearchDelegate<UserItem> {
  final List<UserItem> searchList;

  UserItemSearch(this.searchList);

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_city, size: 120),
            const SizedBox(height: 48),
            Text(
              query,
              style: TextStyle(
                color: Colors.black,
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<UserItem> suggestions = query.isEmpty
        ? searchList
        : searchList.where((product) {
            final productLower = product.productName.toLowerCase();
            final queryLower = query.toLowerCase();

            return productLower.contains(queryLower);
          }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<UserItem> suggestions) =>
      ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          return ListTile(
            onTap: () {}, // TODO: Edit item
            leading: Image.network(
              suggestion.imageURL,
              height: 50,
              width: 50,
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace stackTrace) {
                return SizedBox(
                  height: 50,
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
            title: Text(suggestion.productName),
            subtitle: Text(getExpiryDays(suggestion)),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pop(context, suggestion);
              },
            ),
          );
        },
      );
}

String getExpiryDays(UserItem item) {
  int daysLeft = item.daysLeft;
  String message = '';
  if (daysLeft < 0) {
    message = "Item expired";
  } else if (daysLeft == 0) {
    message = 'expiring today';
  } else if (daysLeft == 1) {
    message = '$daysLeft day left';
  } else {
    message = '$daysLeft days left';
  }

  return message;
}
