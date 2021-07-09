// create item class
import 'package:stockup/models/models.dart';

abstract class DatabaseService {
  // Initialize the account with default data when user sign up.
  Future<void> initialize();

  // Create
  Future<void> addCredentials(Map<String, dynamic> credentials);

  Future<String> addUserItem(UserItem item, UserItemList list);

  Future<String> addUserShop(UserShop item, UserShopList list);

  Future<String> addUserShopList(UserShopList list);

  Future<String> addUserItemList(UserItemList list);

  Future<String> addGiantItem(Product item);

  // Read
  Future<Map<String, dynamic>> getCredentials();

  //Future<List<UserItem>> getUserItems();

  Future<List<Product>> getGiantItems();

  // Update
  Future<void> updateCredentials(Map<String, dynamic> credentials);

  Future<void> updateUserItem(UserItem item, UserItemList list);

  Future<void> updateGiantItem(Product item);

  // Delete
  Future<void> deleteUserItem(UserItem item, UserItemList list);
}
