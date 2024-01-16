import 'package:flutter/material.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/create_sales_screen.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/custom_customer_class.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/custom_product_class.dart';
import 'package:petrolpump/Screens/CreatePage/ViewOrder/viewOrder_mainPage.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';
import 'package:petrolpump/Screens/login_page.dart';
import 'package:petrolpump/Screens/splash_screen.dart';
import 'package:petrolpump/Screens/welcome_page.dart';

class AppRoutes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const mainPage = '/mainPage';
  static const createSalesScreen = '/create_order';
  static const customCustomerList = '/custom_customer';
  static const customProductList = '/custom_product';
  static const print = '/print';
  static const splashScreen = '/splashScreen';
  static const viewOrder='/viewOrder';

  static Route<dynamic> generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case welcome:
        return MaterialPageRoute(builder: (context) => const WelcomePage());
      case login:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case mainPage:
        return MaterialPageRoute(builder: (context) =>  MainPage(initialIndex: 0,));
      case createSalesScreen:
        return MaterialPageRoute(
            builder: (context) => const CreateSalesScreen());

      case customCustomerList:
        return MaterialPageRoute(
            builder: (context) => SelectedContentCustomer());

      case customProductList:
        return MaterialPageRoute(
            builder: (context) => const SelectedContentProduct());

        case viewOrder:
        return MaterialPageRoute(
            builder: (context) =>  ViewOrder());

             default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text("Default page"),
              ),
            );
          },
        );
    }
  }
}