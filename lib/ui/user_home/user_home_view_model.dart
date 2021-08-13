import 'package:sorted_list/sorted_list.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/models/models.dart';
import 'package:stockup/services/services.dart';

class UserHomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  static final _authService = locator<AuthImplementation>();
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();

  List<ExpiredItemData> expiredData =
      SortedList<ExpiredItemData>((r1, r2) => r2.time.compareTo(r1.time));
  Map<String, dynamic> expiredDb;

  List<DoughnutData> categoryWaste = [];

  List<UserItem> expiredItems = [];
  List<UserItem> expiringItems = [];

  int totalItems = 0;
  UserItemList personal;

  bool expiringExcess = false;
  bool expiredExcess = false;

  void init() async {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    await _personalListFromDb();
    await _expiredItemsFromDatabase();
    getExpiredData();
    getDoughnutData();
    await _processItemsinList();
    notifyListeners();
  }

  Future<void> _personalListFromDb() async {
    personal = await _database.getRequestedList(
        'Personal', _authService.appUser.email);
  }

  Future<void> _processItemsinList() async {
    expiredItems.clear();
    expiringItems.clear();
    List<UserItem> all = SortedList<UserItem>(
        (r1, r2) => r2.forCompare.compareTo(r1.forCompare));
    List<UserItem> unordered = await _database.getUserItems(personal);
    totalItems = unordered.length;
    all.addAll(unordered);

    for (UserItem item in all) {
      int daysLeft = item.daysLeft;
      if (daysLeft < 0) {
        //increase expired
        if (expiredItems.length < 6) {
          expiredItems.add(item);
        } else {
          expiredExcess = true;
        }
      } else if (daysLeft < 4) {
        // increase expire soon
        if (expiringItems.length < 6) {
          expiringItems.add(item);
        } else {
          expiringExcess = true;
        }
      } else {
        // break since sorted list so no more items to look through
        break;
      }
    }
  }

  String get expiredTitleMessage {
    if (expiredItems.length == 1) {
      return '${expiredItems.length} item expired';
    } else {
      return '${expiredItems.length} items expired';
    }
  }

  String get name {
    int end = _authService.appUser.email.indexOf('@');
    return 'Hi, ${_authService.appUser.email.substring(0, end)} !';
  }

  String expiredDetail(UserItem item) {
    String message;
    if (item.daysLeft == -1) {
      message = 'Expired ${-item.daysLeft} day ago';
    } else {
      message = 'Expired ${-item.daysLeft} days ago';
    }
    return message;
  }

  String get expiringTitleMessage {
    if (expiringItems.length == 1) {
      return '${expiringItems.length} item expiring soon';
    } else {
      return '${expiringItems.length} items expiring soon';
    }
  }

  String expiringDetail(UserItem item) {
    String message;
    if (item.daysLeft == 1) {
      message = 'Expiring in ${item.daysLeft} day';
    } else if (item.daysLeft == 0) {
      message = 'Expiring today!';
    } else {
      message = 'Expiring in ${item.daysLeft} days';
    }
    return message;
  }

  Future<void> _expiredItemsFromDatabase() async {
    expiredDb = await _database.getExpiredItems();
  }

  void getExpiredData() {
    Map<int, int> map = {};

    for (String cat in expiredDb.keys) {
      expiredDb[cat].forEach((element) {
        if (!map.containsKey(element)) {
          map[element] = 1;
        } else {
          map[element] += 1;
        }
      });
    }

    for (int element in map.keys) {
      ExpiredItemData data = ExpiredItemData(
          DateTime.fromMillisecondsSinceEpoch(element), map[element]);
      expiredData.add(data);
    }
  }

  /// Data source for SF Circular Chart
  void getDoughnutData() {
    for (String category in expiredDb.keys) {
      List<dynamic> expired = expiredDb[category];
      DoughnutData data = DoughnutData(category, expired.length);
      categoryWaste.add(data);
    }
  }

  void signOut() async {
    await _authService.signOut();
    _navigationService.replaceWith(Routes.signInView);
  }

  void viewItems() {
    _navigationService.replaceWith(Routes.userItemView);
    notifyListeners();
  }

  void add() {
    _navigationService.replaceWith(Routes.userScanView);
    notifyListeners();
  }
}

class ExpiredItemData {
  ExpiredItemData(this.time, this.amount);
  final DateTime time;
  final int amount;
}

/// Data type for SF Circular Chart
class DoughnutData {
  final String category;
  final int amount;

  DoughnutData(this.category, this.amount);
}
