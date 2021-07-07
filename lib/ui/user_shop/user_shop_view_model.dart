import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/services/user/user_service.dart';

class UserShopViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final List<String> productCategories = ['All Categories'];
  List<UserShopList> userShopLists = [];
  int no = 1;

  UserShopList get targetUserShopList {
    return _userService.getTargetUSL();
  }

  set targetUserShopList(UserShopList newTarget) {
    _userService.setTargetUSL(newTarget);
    notifyListeners();
  }

  void init() {
    productCategories.addAll((ProductCategory.values.map(
        (ProductCategory category) =>
            category.toString().split('.').last.split('_').join(' '))));
    userShopLists = _userService.getUSLs();
    targetUserShopList = _userService.getTargetUSL();
    notifyListeners();
  }

  void add() {
    _userService.addUserShop(
      UserShop(
        productName: 'Product $no',
        productID: no,
        imageURL: 'url$no',
        category: ProductCategory.values[no % ProductCategory.values.length],
      ),
    );
    ++no;
    notifyListeners();
  }
}
