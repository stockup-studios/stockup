import 'package:flutter/material.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:stockup/services/product_listing.dart';

class Parser {
  final List<String> text;

  Parser({@required this.text});

  List<String> getBestMatches() {
    List<String> matches;
    for (String item in text) {
      BestMatch match = StringSimilarity.findBestMatch(item, productListing);
      Rating best = match.bestMatch;

      // // use for debugging purposes
      // if (best.rating > 0.5)
      //   print('${best.rating}\t$item -> ${best.target}');

      if (best.rating > 0.5) {
        matches.add(best.target);
      }
    }

    return matches;
  }
}
