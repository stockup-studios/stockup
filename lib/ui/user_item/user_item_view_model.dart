import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:stockup/services/user/user_service.dart';

class UserItemViewModel extends BaseViewModel {
  final _userService = locator<UserService>();

  final List<String> productCategories = ['All Categories'];
  List<UserItemList> userItemLists = [];
  List<UserShopList> userShopLists = [];
  UserShopList targetUserShopList;
  int no = 1;

  UserItemList get targetUserItemList {
    return _userService.getTargetUIL();
  }

  set targetUserItemList(UserItemList newTarget) {
    _userService.setTargetUIL(newTarget);
    notifyListeners();
  }

  /// Only called once. Will not be called again on rebuild
  void init() {
    print('user shop view model init called');
    productCategories.addAll((ProductCategory.values.map(
        (ProductCategory category) =>
            category.toString().split('.').last.split('_').join(' '))));
    userItemLists = _userService.getUILs();
    targetUserItemList = _userService.getTargetUIL();
    notifyListeners();
  }

  void add() {
    _userService.addUserItem(UserItem(
      productName: 'Product $no',
      productID: no,
      imageURL: 'url$no',
      category: ProductCategory.values[no % ProductCategory.values.length],
    ));
    ++no;
    notifyListeners();
  }
}
