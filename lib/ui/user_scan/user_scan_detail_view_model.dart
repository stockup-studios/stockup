import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';

class UserScanDetailViewModel extends BaseViewModel {
  UserItem product;
  String _name;
  ProductCategory _category;
  DateTime _expiry;

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

  DateTime get expiry {
    return _expiry;
  }

  set expiry(DateTime expiry) {
    _expiry = expiry;
    notifyListeners();
  }

  void init(UserItem ui) {
    product = ui;
    name = product.productName;
    category = product.category;
    expiry = DateTime.fromMillisecondsSinceEpoch(product.expiryDate);
  }

  void save() {
    product.productName = name;
    product.category = category;
    product.expiryDate = expiry.millisecondsSinceEpoch;
    notifyListeners();
  }
}
