import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qualipro_flutter/Services/licence_service.dart';

import '../Utils/shared_preference.dart';

class SuperMiddleware extends GetMiddleware {

  @override
  int? get priority => 1;

  bool? licence;

  @override
  RouteSettings? redirect(String? route) {
   /* final response = LicenceService().readLicenceInfo();
    if(response == null || response == []) {
      licence = true;
    }
    else {
      licence = false;
    }
     if(LicenceService().readLicenceInfo() != [])  return RouteSettings(name: "/licence");
     if(licence == true) return RouteSettings(name: "/licence"); */

    if(SharedPreference.getLicenceKey() == null)  return RouteSettings(name: "/licence");
  }
}