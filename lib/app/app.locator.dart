// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/auth/auth_impl.dart';
import '../services/parser/parser.dart';
import '../services/scanner/scanner.dart';
import '../services/user/user_service.dart';
import '../ui/sign_in/sign_in_view_model.dart';
import '../ui/user_item/user_item_view_model.dart';
import '../ui/user_shop/user_shop_view_model.dart';

final locator = StackedLocator.instance;

void setupLocator({String environment, EnvironmentFilter environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => AuthImplementation());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => Scanner());
  locator.registerLazySingleton(() => Parser());
  locator.registerSingleton(UserItemViewModel());
  locator.registerSingleton(UserShopViewModel());
  locator.registerSingleton(SignInViewModel());
}
