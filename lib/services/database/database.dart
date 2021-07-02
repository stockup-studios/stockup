// create item class
import 'package:stockup/models/models.dart';

abstract class DatabaseService {
  // Initialize the account with default data when user sign up.
  Future<void> initialize();

  // Create
  Future<void> addCredentials(Map<String, dynamic> credentials);

  Future<String> addUserItem(UserItem item);

  Future<String> addUserShop(UserShop item);

  Future<String> addUserShopList(UserShopList list);

  Future<String> addGiantItem(Product item);

  // Read
  Future<Map<String, dynamic>> getCredentials();

  Future<List<UserItem>> getUserItems();

  Future<List<Product>> getGiantItems();

  // Update
  Future<void> updateCredentials(Map<String, dynamic> credentials);

  Future<void> updateUserItem(UserItem item);

  Future<void> updateGiantItem(Product item);

  // Delete
  Future<void> deleteUserItem(UserItem item);
}
