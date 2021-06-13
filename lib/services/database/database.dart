// create item class
import 'package:stockup/models/item.dart';

abstract class DatabaseService {
  // Initialize the account with default data when user sign up.
  Future<void> initialize();

  // Create
  Future<void> addCredentials(Map<String, dynamic> credentials);

  Future<String> addUserItem(Item item);

  Future<String> addGiantItem(Item item);

  // Read
  Future<Map<String, dynamic>> getCredentials();

  Future<List<Item>> getItems();

  Future<List<Item>> getGiantItems();

  // Update
  Future<void> updateItem(Item item);

  Future<void> updateGiantItem(Item item);

  // Delete
  Future<void> deleteItem(Item item);
}
