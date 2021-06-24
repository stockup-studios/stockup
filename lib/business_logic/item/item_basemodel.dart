import 'package:stockup/business_logic/userData/userData_viewmodel.dart';

abstract class ItemBaseModel {
  /// Initialize the model with UserData.
  void init(UserData userData);

  /// Capture data from image
  Future<void> imageToTempItem();
}
