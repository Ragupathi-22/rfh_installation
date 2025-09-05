import 'package:flutter/material.dart';
import '../app_pages/index_pages.dart';

class AppRoute {
  static Route<dynamic> allRoutes(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      switch (settings.name) {
        case "splash":
          return const SplashScreen();
        case "login":
          return const LoginPage();
        case "adminDashboard":
          return const AdminDashboard();
        case "aspDashboard":
          return const AspDashboard(); // You'll need to create this
        case "mechanicDashboard":
          return const MechanicDashboard(); // You'll need to create this

        // case "otpVerification":
        //   final String mobileNo = settings.arguments as String;
        //   return OtpVerification(
        //     mobileNo: mobileNo,
        //   );
      }
      return const LoginPage();
    });
  }
}
