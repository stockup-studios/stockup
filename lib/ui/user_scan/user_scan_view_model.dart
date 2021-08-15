import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/models/product_catalog/product_catalog.dart';
import 'package:stockup/services/services.dart';

class UserScanViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();
  static final _authService = locator<AuthImplementation>();
  final _scanner = locator<Scanner>();
  final _parser = locator<Parser>();

  final List<UserItem> _productMatches = [];
  String foundNoTextError = '';

  List<UserItem> get productMatches => _productMatches;

  UserItemList _currentList;

  void init() async {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    await _targetUserItemListFromDatabase();
    notifyListeners();
  }

  Future<void> _targetUserItemListFromDatabase() async {
    _currentList = await _database.getTargetItemList();
  }

  void addFile() async {
    String imageFile = await _scanner.getImageFilePath();
    setBusy(true);
    List<String> text = await _scanner.getTextFromImageFile(imageFile);
    List<String> matches = _parser.getBestMatches(text);
    foundNoTextError = (matches.length == 0)
        ? "Couldn't find any details. Receipt picture might be rotated"
        : '';
    for (String match in matches) {
      Product p =
          productCatalog.firstWhere((product) => product.productName == match);
      UserItem userItem = UserItem(
          productName: p.productName,
          productID: p.productID,
          category: p.category,
          imageURL: p.imageURL,
          expiryDate: UserItem.getRecommendedExpiry(p.category));
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
        Product p = productCatalog
            .firstWhere((product) => product.productName == match);
        UserItem userItem = UserItem(
            productName: p.productName,
            productID: p.productID,
            category: p.category,
            imageURL: p.imageURL,
            expiryDate: UserItem.getRecommendedExpiry(p.category));
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
      _database.addUserItem(ui, _currentList);
    }
    _productMatches.clear();
    notifyListeners();
    _navigationService.replaceWith(Routes.userItemView);
  }

  void duplicate(int index) {
    UserItem current = _productMatches[index];
    UserItem duplicate = UserItem(
      productName: current.productName,
      productID: current.productID,
      category: current.category,
      imageURL: current.imageURL,
      expiryDate: current.expiryDate,
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
