// create item class
abstract class DatabaseService {
  // Initialize the account with default data when user sign up.
  Future<void> initialize();

  // Create
  Future<void> addCredentials(Map<String, dynamic> credentials);

  Future<String> addItem(Item item);

  // Read
  Future<Map<String, dynamic>> getCredentials();

  Future<List<Item>> getItems();

  // Update
  Future<void> updateItem(Item item);

  // Delete
  Future<void> deleteItem(Item item);
}
