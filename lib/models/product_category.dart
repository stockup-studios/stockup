enum ProductCategory {
  fruit_vegetables,
  meats_seafood,
  bakery_cereals_spreads,
  dairy_chilled_frozen,
  snacks_drinks,
  beers_wines_spirits,
  food_pantry,
  others,
}

extension CategoryExtension on ProductCategory {
  String get name {
    switch (this) {
      case ProductCategory.bakery_cereals_spreads:
        return 'Bakery, Cereals & Spreads';
      case ProductCategory.beers_wines_spirits:
        return 'Beer, Wine & Spirit';
      case ProductCategory.dairy_chilled_frozen:
        return 'Dairy Chilled & Frozen';
      case ProductCategory.food_pantry:
        return 'Food Pantry';
      case ProductCategory.fruit_vegetables:
        return 'Fruit & Vegetables';
      case ProductCategory.meats_seafood:
        return 'Meats & Seafood';
      case ProductCategory.snacks_drinks:
        return 'Snacks & Drinks';
      case ProductCategory.others:
        return 'Others';
      default:
        return null;
    }
  }

  static ProductCategory getCategory(String category) {
    if (category.contains('Fruit & Vegetables')) {
      return ProductCategory.fruit_vegetables;
    } else if (category.contains('Food Pantry')) {
      return ProductCategory.food_pantry;
    } else if (category.contains('Diary, Chilled & Frozen')) {
      return ProductCategory.dairy_chilled_frozen;
    } else if (category.contains('Bakery, Cereals & Spreads')) {
      return ProductCategory.bakery_cereals_spreads;
    } else if (category.contains('Beer, Wine & Spirit')) {
      return ProductCategory.beers_wines_spirits;
    } else if (category.contains('Meats & Seafood')) {
      return ProductCategory.meats_seafood;
    } else if (category.contains('Snacks & Drinks')) {
      return ProductCategory.snacks_drinks;
    } else {
      return ProductCategory.others;
    }
  }
}
