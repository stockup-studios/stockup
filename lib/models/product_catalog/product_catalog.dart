import 'package:stockup/models/product_catalog/bakery_cereals_spreads.dart';
import 'package:stockup/models/product_catalog/beers_wines_spirits.dart';
import 'package:stockup/models/product_catalog/dairy_chilled_frozen.dart';
import 'package:stockup/models/product_catalog/food_pantry.dart';
import 'package:stockup/models/product_catalog/fruit_vegetables.dart';
import 'package:stockup/models/product_catalog/meats_seafood.dart';
import 'package:stockup/models/product_catalog/snacks_drinks.dart';
import '../product.dart';

List<Product> productCatalog = bakeryCerealsSpreadsCatalog +
    beersWinesSpiritsCatalog +
    dairyChilledFrozenCatalog +
    foodPantryCatalog +
    fruitVegetablesCatalog +
    meatsSeafoodCatalog +
    snacksDrinksCatalog;

List<String> productNamesCatalog =
    productCatalog.map((Product product) => product.productName).toList();
