import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/product_category.dart';
import 'package:stockup/models/user_shop.dart';
import 'package:stockup/models/user_shop_list.dart';
import 'package:http/http.dart' as http;
import 'package:stockup/services/services.dart';

class UserShopAddViewModel extends BaseViewModel {
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();

  UserShopList userShopList;

  /// required fields for adding new shop item
  String _name;
  ProductCategory _category;
  int _quantity;
  String _imageURL;

  List<String> imageFormats = ['png', 'jpeg', 'jpg', 'tiff', 'tif'];

  /// used for error messages on view
  String _nameError = '';
  String _imageError = '';
  String _quantityError = '';

  String get nameError {
    return _nameError;
  }

  set nameError(String message) {
    _nameError = message;
    notifyListeners();
  }

  String get imageError {
    return _imageError;
  }

  set imageError(String message) {
    _imageError = message;
    notifyListeners();
  }

  String get quantityError {
    return _quantityError;
  }

  set quantityError(String message) {
    _quantityError = message;
    notifyListeners();
  }

  /// standard getters and setters with notifyListeners
  String get name {
    return _name;
  }

  set name(String name) {
    _name = name;
    checkName();
    notifyListeners();
  }

  ProductCategory get category {
    return _category;
  }

  set category(ProductCategory category) {
    _category = category;
    notifyListeners();
  }

  int get quantity {
    return _quantity;
  }

  set quantity(int quantity) {
    _quantity = quantity;
    notifyListeners();
  }

  String get imageURL {
    return _imageURL;
  }

  set imageURL(String imageURL) {
    _imageURL = imageURL;
    notifyListeners();
  }

  /// initialization code. Will be run on build
  void init(UserShopList userShopList) {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    this.userShopList = userShopList;
    this.name = '';
    this.imageURL = '';
    this.category = ProductCategory.others;
    this.quantity = 1;
  }

  void addQuantity() {
    ++quantity;
  }

  void delQuantity() {
    if (quantity > 1) {
      --quantity;
    }
  }

  void changeQuantity(String newVal) {
    int newQuantity = -1;
    try {
      newQuantity = int.parse(newVal);
      if (newQuantity > 0) {
        quantity = newQuantity;
        quantityError = '';
      } else
        throw ('Invalid quantity');
    } catch (e) {
      quantityError = 'Invalid quantity';
    }
  }

  /// check that name is valid
  void checkName() {
    nameError = (name == '') ? 'Item name cannot be empty' : '';
  }

  /// check that image from url is valid and is a common image format
  Future<void> checkImage() async {
    if (imageURL == '') {
      imageURL =
          'https://toppng.com/uploads/preview/shopping-cart-115309972353g1kktalus.png';
      imageError = '';
      return;
    }
    var url;
    var response;
    try {
      url = Uri.parse(imageURL);
      response = await http.get(url);
      if (response.statusCode != 200) {
        imageError = 'Invalid image URL';
        return;
      }
    } catch (e) {
      imageError = 'Invalid image URL';
      return;
    }

    if (!imageFormats.contains(imageURL.split('.').last)) {
      imageError =
          'Image URL must end in a common image format (jpg, jpeg, png)';
      return;
    }

    imageError = '';
  }

  /// to add new item to userShopList
  Future<bool> add() async {
    checkName();
    await checkImage();
    if (nameError == '' && imageError == '' && quantityError == '') {
      UserShop userShop = UserShop(
          productName: name,
          productID: -1,
          category: category,
          imageURL: imageURL,
          quantity: quantity);

      _database.addUserShop(userShop, userShopList);
      return true;
    }
    return false;
  }
}
