// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/sign_in/sign_in_view.dart';
import '../ui/sign_up/sign_up_view.dart';
import '../ui/user_home/user_home_view.dart';
import '../ui/user_item/user_item_list/user_item_view.dart';
import '../ui/user_scan/user_scan_view.dart';
import '../ui/user_shop/user_shop_view.dart';
import '../ui/welcome/welcome_view.dart';

class Routes {
  static const String welcomeView = '/';
  static const String signInView = '/sign-in-view';
  static const String signUpView = '/sign-up-view';
  static const String userHomeView = '/user-home-view';
  static const String userItemView = '/user-item-view';
  static const String userScanView = '/user-scan-view';
  static const String userShopView = '/user-shop-view';
  static const all = <String>{
    welcomeView,
    signInView,
    signUpView,
    userHomeView,
    userItemView,
    userScanView,
    userShopView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.welcomeView, page: WelcomeView),
    RouteDef(Routes.signInView, page: SignInView),
    RouteDef(Routes.signUpView, page: SignUpView),
    RouteDef(Routes.userHomeView, page: UserHomeView),
    RouteDef(Routes.userItemView, page: UserItemView),
    RouteDef(Routes.userScanView, page: UserScanView),
    RouteDef(Routes.userShopView, page: UserShopView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    WelcomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const WelcomeView(),
        settings: data,
      );
    },
    SignInView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SignInView(),
        settings: data,
      );
    },
    SignUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SignUpView(),
        settings: data,
      );
    },
    UserHomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const UserHomeView(),
        settings: data,
      );
    },
    UserItemView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const UserItemView(),
        settings: data,
      );
    },
    UserScanView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const UserScanView(),
        settings: data,
      );
    },
    UserShopView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const UserShopView(),
        settings: data,
      );
    },
  };
}
