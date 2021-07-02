import 'package:stockup/models/models.dart';

abstract class UserDataBaseModel {
  /// Initialize the model with UserData.
  Future<void> init(AppUser user);

  /// CREATE
  Future<void> addUserItem(UserItem item, bool toDatabase);

  /// READ
  List<UserItem> get items;

  /// UPDATE
  Future<void> updateItem(UserItem item);

  /// Clear all demo data and initialize the user with empty state.
  Future<void> demoDone();

  /// DELETE
  Future<void> deleteUserItem(UserItem item);
}
