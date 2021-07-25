import 'package:stacked/stacked.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/models/user_item_list.dart';
import 'package:http/http.dart' as http;

String apiKey = 'f1798c4b05msh0ea4de1e4b0963cp11bc95jsn389dca3fa79b';

class UserItemAddViewModel extends BaseViewModel {
  UserItemList userItemList;

  /// required fields for adding new item
  String _name;
  ProductCategory _category;
  DateTime _expiry;
  String _imageURL;

  List<String> imageFormats = ['png', 'jpeg', 'jpg', 'tiff', 'tif'];

  /// used for error messages on view
  String _nameError = 'Item name cannot be empty';
  String _imageError = '';

  String get nameError {
    return _nameError;
  }

  String get imageError {
    return _imageError;
  }

  /// standard getters and setters with notifyListeners
  String get name {
    return _name;
  }

  set name(String name) {
    _nameError = (name == '') ? 'Item name cannot be empty' : '';
    _name = name;
    notifyListeners();
  }

  ProductCategory get category {
    return _category;
  }

  set category(ProductCategory category) {
    _category = category;
    notifyListeners();
  }

  DateTime get expiry {
    return _expiry;
  }

  set expiry(DateTime expiry) {
    _expiry = expiry;
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
  void init(UserItemList userItemList) {
    this.userItemList = userItemList;
    this.name = '';
    this.imageURL = '';
    this.category = ProductCategory.others;
    this.expiry = DateTime.now();
  }

  Future<void> checkImage() async {
    if (imageURL == '') {
      imageURL =
          'https://previews.123rf.com/images/wangsinawang/wangsinawang1807/wangsinawang180700403/114807640-restaurant-icon-vector.jpg';
      _imageError = '';
      notifyListeners();
      return;
    }
    var url;
    var response;
    try {
      url = Uri.parse(imageURL);
      response = await http.get(url);
      if (response.statusCode != 200) {
        _imageError = 'Invalid image URL';
        notifyListeners();
        return;
      }
    } catch (e) {
      _imageError = 'Invalid image URL';
      notifyListeners();
      return;
    }

    if (!imageFormats.contains(imageURL.split('.').last)) {
      _imageError = 'Image URL must end in a common image format';
      notifyListeners();
      return;
    }

    _imageError = '';
  }

  /// to add new item to userItemList
  Future<bool> add() async {
    await checkImage();
    if (nameError == '' && imageError == '') {
      UserItem userItem = UserItem(
          productName: name,
          productID: -1,
          category: category,
          imageURL: imageURL);
      userItem.expiryDate = expiry.millisecondsSinceEpoch;
      userItemList.addUserItem(userItem);
      return true;
    }
    return false;
  }
}
