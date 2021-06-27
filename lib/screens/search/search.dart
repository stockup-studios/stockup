import 'package:flutter/material.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_catalog/product_catalog.dart';

class SearchScreen extends StatelessWidget {
  static const String id = 'search_screen';
  final String title = 'Search Items';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              // showSearch(context: context, delegate: ProductSearch());

              // final results = await
              showSearch(context: context, delegate: ProductSearch());

              // print('Result: $results');
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text(
            'Search product catalog',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 64,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ProductSearch extends SearchDelegate<Product> {
  final List<Product> searchHistory = [
    productCatalog[100],
    productCatalog[200],
    productCatalog[300]
  ];

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
    final List<Product> suggestions = query.isEmpty
        ? searchHistory
        : productCatalog.where((product) {
            final productLower = product.productName.toLowerCase();
            final queryLower = query.toLowerCase();

            return productLower.contains(queryLower);
          })
            // .map((Product product) => product.productName)
            .toList();

    return buildSuggestionsSuccess(suggestions);
  }

  Widget buildSuggestionsSuccess(List<Product> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          // final queryText = suggestion.substring(0, query.length);
          // final remainingText = suggestion.substring(query.length);
          return ListTile(
            onTap: () {
              query = suggestion.productName;
              searchHistory.add(suggestion);
              // 1. Show Results
              // showResults(context);

              // 2. Close Search & Return Result
              close(context, suggestion);

              // 3. Navigate to Result Page
              //  Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (BuildContext context) => ResultPage(suggestion),
              //   ),
              // );
            },
            leading: Image.network(suggestion.imageURL) ??
                Container(color: Colors.black),
            title: Text(suggestion.productName),
            subtitle: Text(suggestion.category.toString().split('.').last),
            trailing: Icon(Icons.add),
            // title: RichText(
            //   text: TextSpan(
            //     text: queryText,
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontWeight: FontWeight.bold,
            //       fontSize: 18,
            //     ),
            //     children: [
            //       TextSpan(
            //         text: remainingText,
            //         style: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 18,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          );
        },
      );
}

// code modified from https://github.com/JohannesMilke/search_appbar_example/blob/master/lib/page/local_search_appbar_page.dart
