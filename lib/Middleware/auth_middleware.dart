import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/shared_preference.dart';

class AuthMiddleware extends GetMiddleware {

  @override
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    if(SharedPreference.getMatricule() != null)  return RouteSettings(name: "/home");

  }
}