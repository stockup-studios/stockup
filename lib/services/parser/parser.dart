import 'package:flutter/material.dart';
import 'package:stockup/models/product_catalog/product_catalog.dart';
import 'package:stockup/services/database/database_impl.dart';
import 'package:string_similarity/string_similarity.dart';

class Parser {
  final List<String> text;

  Parser({@required this.text});

  DatabaseServiceImpl _db = DatabaseServiceImpl();

  List<String> _productListing;

  Future<void> getProductListing() async {
    _productListing = await _db.productListing();
  }

  static List<String> getBestMatches(List<String> text) {
    List<String> matches = [];

    for (String item in text) {
      BestMatch match =
          StringSimilarity.findBestMatch(item, productNamesCatalog);
      Rating best = match.bestMatch;

      // // use for debugging purposes
      // if (best.rating > 0.5)
      //   print('${best.rating}\t$item -> ${best.target}');

      if (best.rating > 0.5) {
        String closestMatch = best.target;
        matches.add(closestMatch);
      }
    }

    return matches;
  }
}
