import 'package:calculator_app/routes/routes.dart';
import 'package:calculator_app/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesName.homeScreen,
      getPages: AppRoutes.appRoutes(),
    );
  }
}
