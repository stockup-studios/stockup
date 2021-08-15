import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/services.dart';

class UserShopDetailViewModel extends BaseViewModel {
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();

  UserShopList currentList;
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
      print(e);
    }
  }

  void init(
    UserShop ui,
    UserShopList list,
  ) {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    userShop = ui;
    currentList = list;
    name = userShop.productName;
    category = userShop.category;
    quantity = userShop.quantity;
  }

  void save() {
    userShop.category = category;
    userShop.quantity = quantity;
    _database.updateUserShop(userShop, currentList);
    notifyListeners();
  }
}
