import 'package:flutter/material.dart';
import 'package:stockup/models/models.dart';

class UserShopSearch extends SearchDelegate<UserShop> {
  final List<UserShop> searchList;

  UserShopSearch(this.searchList);

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
    final List<UserShop> suggestions = query.isEmpty
        ? searchList
        : searchList.where((product) {
            final productLower = product.productName.toLowerCase();
            final queryLower = query.toLowerCase();

            return productLower.contains(queryLower);
          }).toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<UserShop> suggestions) =>
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
            // leading: Image.network(suggestion.imageURL) ??
            //     Container(color: Colors.black),
            title: Text(suggestion.productName),
            subtitle: Text('Quantity: ${suggestion.quantity.toString()}'),
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
