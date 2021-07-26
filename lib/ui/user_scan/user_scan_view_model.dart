import 'package:stacked/stacked.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/models/product.dart';
import 'package:stockup/models/product_catalog/product_catalog.dart';
import 'package:stockup/models/user_item.dart';
import 'package:stockup/services/parser/parser.dart';
import 'package:stockup/services/scanner/scanner.dart';
import 'package:stockup/services/user/user_service.dart';

class UserScanViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _scanner = locator<Scanner>();
  final _parser = locator<Parser>();
  final List<UserItem> _productMatches = [];
  String foundNoTextError = '';

  List<UserItem> get productMatches => _productMatches;

  void addFile() async {
    String imageFile = await _scanner.getImageFilePath();
    setBusy(true);
    List<String> text = await _scanner.getTextFromImageFile(imageFile);
    List<String> matches = _parser.getBestMatches(text);
    foundNoTextError = (matches.length == 0)
        ? "Couldn't find any details. Receipt picture might be rotated"
        : '';
    for (String match in matches) {
      print(match);
      Product p =
          productCatalog.firstWhere((product) => product.productName == match);
      UserItem userItem = UserItem(
          productName: p.productName,
          productID: p.productID,
          category: p.category,
          imageURL: p.imageURL);
      _productMatches.add(userItem);
    }
    setBusy(false);
    notifyListeners();
  }

  void addFiles() async {
    List<String> imageFiles = await _scanner.getImageFilePaths();
    setBusy(true);
    bool added = false;
    for (String imageFile in imageFiles) {
      List<String> text = await _scanner.getTextFromImageFile(imageFile);
      List<String> matches = _parser.getBestMatches(text);
      for (String match in matches) {
        added = true;
        print(match);
        Product p = productCatalog
            .firstWhere((product) => product.productName == match);
        UserItem userItem = UserItem(
            productName: p.productName,
            productID: p.productID,
            category: p.category,
            imageURL: p.imageURL);
        _productMatches.add(userItem);
      }
    }
    foundNoTextError = added
        ? ''
        : "Some receipt pictures may be rotated. Skipped those we couldn't find any details";
    setBusy(false);
    notifyListeners();
  }

  void addToItems() {
    for (UserItem ui in _productMatches) {
      _userService.addUserItem(ui);
    }
    _productMatches.clear();
    notifyListeners();
  }

  void duplicate(int index) {
    UserItem current = _productMatches[index];
    UserItem duplicate = UserItem(
      productName: current.productName,
      productID: current.productID,
      category: current.category,
      imageURL: current.imageURL,
    );
    duplicate.expiryDate = current.expiryDate;
    _productMatches.insert(index, duplicate);
    notifyListeners();
  }

  void delete(int index) {
    _productMatches.removeAt(index);
    notifyListeners();
  }

  void noItems() {
    foundNoTextError = 'Scan some items first!';
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}
