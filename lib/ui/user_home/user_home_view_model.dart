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

  /// temp variables only for UI testing. Use version taken from database for actual
  // int noExpired = 1;
  // int noExpiringSoon = 1;
  // int totalItems = 1;

  List<ExpiredItemData> expiredData = [];
  // List<int> expiredDb = [];
  Map<String, dynamic> expiredDb;

  List<UserItem> expiredItems = [];
  List<UserItem> expiringItems = [];
  int totalItems = 0;
  UserItemList personal;

  void init() async {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    await getExpiredData();
    await _personalListFromDb();
    await _processItemsinList();
    print('home view model init called');
    notifyListeners();
  }

  Future<void> _personalListFromDb() async {
    personal = await _database.getRequestedList(
        'Personal', _authService.appUser.email);
    print('user home personal list is ${personal != null}');
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
        }
      } else if (daysLeft < 4) {
        // increase expire soon
        if (expiringItems.length < 6) {
          expiringItems.add(item);
        }
      } else {
        // break since sorted list so no more items to look through
        break;
      }
    }

    print('expired items ${expiredItems.length}');
    print('expiring items ${expiringItems.length}');
  }

  String get expiredTitleMessage {
    if (expiredItems.length == 1) {
      return '${expiredItems.length} item expired';
    } else {
      return '${expiredItems.length} items expired';
    }
  }

  List<String> get expiredDetailMessage {
    List<String> messages = [];
    for (UserItem item in expiredItems) {
      String message;

      if (item.daysLeft == -1) {
        message = '${-item.daysLeft} day ago | ${item.productName}';
      } else {
        message = '${-item.daysLeft} days ago | ${item.productName}';
      }
      messages.add(message);
    }
    return messages;
  }

  String get expiringTitleMessage {
    if (expiringItems.length == 1) {
      return '${expiringItems.length} item expiring soon';
    } else {
      return '${expiringItems.length} items expiring soon';
    }
  }

  List<String> get expiringDetailMessage {
    List<String> messages = [];
    for (UserItem item in expiringItems) {
      String message;
      if (item.daysLeft == 1) {
        message = '${item.daysLeft} day left | ${item.productName}';
      } else if (item.daysLeft == 0) {
        message = 'expiring today | ${item.productName}';
      } else {
        message = '${item.daysLeft} days left | ${item.productName}';
      }
      messages.add(message);
    }
    return messages;
  }

  Future<void> _expiredItemsFromDatabase() async {
    expiredDb = await _database.getExpiredItems();
    //expiredDb = await _database.getExpiredItems();
  }

  Future<void> getExpiredData() async {
    Map<String, Map<int, int>> map = {
      'Bakery, Cereals & Spreads': {},
      'Beer, Wine & Spirit': {},
      'Dairy, Chilled & Frozen': {},
      'Food Pantry': {},
      'Fruit & Vegetables': {},
      'Meats & Seafood': {},
      'Snacks & Drinks': {},
      'Others': {},
    };

    await _expiredItemsFromDatabase();

    for (String cat in expiredDb.keys) {
      expiredDb[cat].forEach((element) {
        if (!map[cat].containsKey(element)) {
          map[cat][element] = 1;
        } else {
          map[cat][element] += 1;
        }
      });
    }

    for (String cat in map.keys) {
      //what to do with cat?
      for (int element in map[cat].keys) {
        ExpiredItemData data = ExpiredItemData(
            DateTime.fromMillisecondsSinceEpoch(element), map[cat][element]);
        expiredData.add(data);
      }
    }
  }

  void signOut() async {
    await _authService.signOut();
    _navigationService.replaceWith(Routes.welcomeView);
  }

  void viewItems() {
    _navigationService.replaceWith(Routes.userItemView);
    notifyListeners();
  }

  void add() {
    _navigationService.replaceWith(Routes.userScanView);
    notifyListeners();
  }

  // final List<List<String>> messages = [
  //   [
  //     '1 Item Expired',
  //     'Yesterday | Marigold HL Milk',
  //   ],
  //   [
  //     '2 Items Expiring Soon',
  //     '2 days | Golden Churn Butter Block - Salted',
  //     '3 days | UFC Refresh 100% Natural Coconut Water',
  //   ],
  //   [
  //     '1 Shared List',
  //   ],
  // ];
}

class ExpiredItemData {
  ExpiredItemData(this.time, this.amount);
  final DateTime time;
  final int amount;
}
