import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';

class UserShopDetailViewModel extends BaseViewModel {
  UserShop userShop;
  String name;
  ProductCategory _category;
  int _quantity;

  ProductCategory get category {
    return _category;
  }

  set category(ProductCategory category) {
    _category = category;
    notifyListeners();
  }

  int get quantity {
    return _quantity;
  }

  set quantity(int quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  void addQuantity() {
    ++quantity;
  }

  void delQuantity() {
    if (quantity > 1) {
      --quantity;
    }
  }

  void changeQuantity(String newVal) {
    int newQuantity = -1;
    try {
      newQuantity = int.parse(newVal);
      if (newQuantity > 0) {
        quantity = newQuantity;
      }
    } catch (e) {
      // TODO: Display error message
    }
  }

  void init(UserShop ui) {
    userShop = ui;
    name = userShop.productName;
    category = userShop.category;
    quantity = userShop.quantity;
  }

  void save() {
    userShop.category = category;
    userShop.quantity = quantity;
    notifyListeners();
  }
}
