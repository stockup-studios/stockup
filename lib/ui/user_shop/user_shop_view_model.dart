import 'package:stacked/stacked.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';

class UserShopViewModel extends BaseViewModel {
  final List<String> productCategories = ['All Categories'];
  List<UserShopList> userShopLists = [];
  UserShopList _targetUserShopList;
  int no = 1;

  UserShopList get targetUserShopList {
    return _targetUserShopList;
  }

  set targetUserShopList(UserShopList newTarget) {
    _targetUserShopList = newTarget;
    notifyListeners();
  }

  void init() {
    productCategories.addAll((ProductCategory.values.map(
        (ProductCategory category) =>
            category.toString().split('.').last.split('_').join(' '))));
    userShopLists.add(UserShopList(name: 'List 1'));
    userShopLists.add(UserShopList(name: 'List 2'));
    targetUserShopList = userShopLists[0];
    targetUserShopList.userShopListing.add(
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

  void add() {
    targetUserShopList.userShopListing.add(
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

  void toggleUserShopList(int index) {
    targetUserShopList = userShopLists[index];
    notifyListeners();
  }
}
