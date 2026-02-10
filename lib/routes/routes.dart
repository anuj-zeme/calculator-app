import 'package:calculator_app/routes/routes_name.dart';
import 'package:calculator_app/screens/home_screen/index.dart';
import 'package:get/get.dart';

class AppRoutes {
  static appRoutes() => [
    GetPage(name: RoutesName.homeScreen, page: () => HomeScreen()),
  ];
}
