import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/app/app.locator.dart';
import 'package:stockup/app/app.router.dart';
import 'package:stockup/services/services.dart';

class UserHomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  static final _authService = locator<AuthImplementation>();
  DatabaseServiceImpl _database = locator<DatabaseServiceImpl>();

  List<ExpiredItemData> expiredData = [];
  List<int> expiredDb = [];

  void init() async {
    _database = DatabaseServiceImpl(uid: _authService.appUser.username);
    await getExpiredData();
    print('home view model init called');
    notifyListeners();
  }

  Future<void> _expiredItemsFromDatabase() async {
    expiredDb = await _database.getExpiredItems();
  }

  Future<void> getExpiredData() async {
    await _expiredItemsFromDatabase();
    int current = 0;
    int count = 0;
    for (int i = 0; i < expiredDb.length; i++) {
      if (current != expiredDb[i]) {
        ExpiredItemData temp = ExpiredItemData(
            DateTime.fromMillisecondsSinceEpoch(current), count);
        expiredData.add(temp);

        current = expiredDb[i];
        count = 0;
      } else {
        count += 1;
      }
    }
  }

  void signOut() async {
    await _authService.signOut();
    _navigationService.replaceWith(Routes.welcomeView);
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

  // final List<ExpiredItemData> expiredItemData = [
  //   // ExpiredItemData(DateTime.now(), 7),
  //   // ExpiredItemData(DateTime.now().add(Duration(days: 1)), 5),
  //   // ExpiredItemData(DateTime.now().add(Duration(days: 2)), 4),
  //   // ExpiredItemData(DateTime.now().add(Duration(days: 3)), 2),
  //   // ExpiredItemData(DateTime.now().add(Duration(days: 4)), 1),
  // ];
}

class ExpiredItemData {
  ExpiredItemData(this.time, this.amount);
  final DateTime time;
  final int amount;
}
