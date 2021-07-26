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
  int noExpired = 1;
  int noExpiringSoon = 1;
  int totalItems = 1;

  List<ExpiredItemData> expiredData = [];
  List<int> expiredDb = [];

  List<UserItem> expiredItems = [];
  List<UserItem> expiringItems = [];
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
    List<UserItem> all = SortedList<UserItem>(
        (r1, r2) => r2.forCompare.compareTo(r1.forCompare));
    List<UserItem> unordered = await _database.getUserItems(personal);
    totalItems = unordered.length;
    all.addAll(unordered);

    for (UserItem item in all) {
      int daysLeft = item.daysLeft;
      if (daysLeft <= 0) {
        //increase expired
        expiredItems.add(item);
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

  Future<void> _expiredItemsFromDatabase() async {
    expiredDb = await _database.getExpiredItems();
  }

  Future<void> getExpiredData() async {
    Map<int, int> map = {};
    await _expiredItemsFromDatabase();

    expiredDb.forEach((element) {
      if (!map.containsKey(element)) {
        map[element] = 1;
      } else {
        map[element] += 1;
      }
    });
    for (int element in map.keys) {
      ExpiredItemData data = ExpiredItemData(
          DateTime.fromMillisecondsSinceEpoch(element), map[element]);
      expiredData.add(data);
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

  final List<List<String>> messages = [
    [
      '1 Item Expired',
      'Yesterday | Marigold HL Milk',
    ],
    [
      '2 Items Expiring Soon',
      '2 days | Golden Churn Butter Block - Salted',
      '3 days | UFC Refresh 100% Natural Coconut Water',
    ],
    [
      '1 Shared List',
    ],
  ];
}

class ExpiredItemData {
  ExpiredItemData(this.time, this.amount);
  final DateTime time;
  final int amount;
}
