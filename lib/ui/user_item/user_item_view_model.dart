import 'package:stacked/stacked.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:stockup/models/user_shop_list.dart';

class UserItemViewModel extends BaseViewModel {
  final List<String> productCategories = ['All Categories'];
  List<UserItemList> userItemLists = [];
  List<UserShopList> userShopLists = [];
  UserItemList _targetUserItemList;
  UserShopList targetUserShopList;
  int no = 1;

  UserItemList get targetUserItemList {
    return _targetUserItemList;
  }

  set targetUserItemList(UserItemList newTarget) {
    _targetUserItemList = newTarget;
    notifyListeners();
  }

  void init() {
    productCategories.addAll((ProductCategory.values.map(
        (ProductCategory category) =>
            category.toString().split('.').last.split('_').join(' '))));
    userItemLists.add(UserItemList(name: 'List 1'));
    userItemLists.add(UserItemList(name: 'List 2'));
    targetUserItemList = userItemLists[0];
    targetUserItemList.userItemListing.add(
      UserItem(
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
    targetUserItemList.userItemListing.add(
      UserItem(
        productName: 'Product $no',
        productID: no,
        imageURL: 'url$no',
        category: ProductCategory.values[no % ProductCategory.values.length],
      ),
    );
    ++no;
    notifyListeners();
  }

  void toggleUserItemList(int index) {
    targetUserItemList = userItemLists[index];
    notifyListeners();
  }
}
