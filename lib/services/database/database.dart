// create item class
import 'package:stockup/models/models.dart';

abstract class DatabaseService {
  // Initialize the account with default data when user sign up.
  Future<void> initialize();

  // Create
  Future<void> addCredentials(Map<String, dynamic> credentials);

  // Future<void> addAppUser(AppUser user);

  Future<String> addUserItem(UserItem item, UserItemList list);

  Future<String> addUserShop(UserShop item, UserShopList list);

  Future<String> addUserShopList(UserShopList list);

  Future<String> addUserItemList(UserItemList list);

  Future<void> addUserItemListforUser(UserItemList list);

  Future<void> addUserShopListforUser(UserShopList list);

  Future<void> addTargetShopList(UserShopList list);

  Future<void> addTargetItemList(UserItemList list);

  Future<String> addGiantItem(Product item);

  // Read
  Future<Map<String, dynamic>> getCredentials();

  Future<List<UserItem>> getUserItems(UserItemList list);

  Future<List<UserShop>> getUserShops(UserShopList list);

  //get all user_item_list specific to user
  Future<List<UserItemList>> getUserItemLists();

  //get all user_shop_list specific to user
  Future<List<UserShopList>> getUserShopLists();

  Future<UserShopList> getTargetShopList();

  Future<UserItemList> getTargetItemList();

  Future<List<Product>> getGiantItems();

  Future<List<String>> getItemListUsers(UserItemList list);

  // Update
  Future<void> updateCredentials(Map<String, dynamic> credentials);

  Future<void> updateUserItem(UserItem item, UserItemList list);

  Future<void> updateUserShop(UserShop item, UserShopList list);

  Future<void> updateUserShopList(UserShopList list);

  Future<void> updateUserItemList(UserItemList list);

  Future<void> updateTargetItemList(UserItemList list);

  Future<void> updateTargetShopList(UserShopList list);

  Future<void> updateGiantItem(Product item);

  // Delete
  Future<void> deleteUserItem(UserItem item, UserItemList list);

  Future<void> deleteUserShop(UserShop item, UserShopList list);

  Future<void> deleteUserItemList(UserItemList list);

  Future<void> deleteUserShopList(UserShopList list);

  Future<void> deleteUserItemListforUser(UserItemList list);

  Future<void> deleteUserShopListforUser(UserShopList list);
}
