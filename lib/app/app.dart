import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stockup/ui/sign_in/sign_in_view.dart';
import 'package:stockup/ui/sign_up/sign_up_view.dart';
import 'package:stockup/ui/user_home/user_home_view.dart';
import 'package:stockup/ui/user_item/user_item_view.dart';
import 'package:stockup/ui/user_item/user_item_view_model.dart';
import 'package:stockup/ui/user_scan/user_scan_view.dart';
import 'package:stockup/ui/user_shop/user_shop_view.dart';
import 'package:stockup/ui/user_shop/user_shop_view_model.dart';
import 'package:stockup/ui/welcome/welcome_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: WelcomeView),
    MaterialRoute(page: SignInView),
    MaterialRoute(page: SignUpView),
    MaterialRoute(page: UserHomeView),
    MaterialRoute(page: UserItemView, initial: true),
    MaterialRoute(page: UserScanView),
    MaterialRoute(page: UserShopView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    Singleton(classType: UserItemViewModel),
    Singleton(classType: UserShopViewModel),
  ],
)
class AppSetup {}
