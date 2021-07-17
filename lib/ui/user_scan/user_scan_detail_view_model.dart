import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';

class UserScanDetailViewModel extends BaseViewModel {
  Product product;
  String _name;
  ProductCategory _category;

  ProductCategory get category {
    return _category;
  }

  set category(ProductCategory category) {
    _category = category;
    notifyListeners();
  }

  String get name {
    return _name;
  }

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  void init(Product ui) {
    product = ui;
    name = product.productName;
    category = product.category;
  }

  void save() {
    product.productName = name;
    product.category = category;
    notifyListeners();
  }
}
