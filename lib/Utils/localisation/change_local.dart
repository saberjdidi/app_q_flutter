import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../shared_preference.dart';

class TranslationController extends GetxController {
  Locale? language ;

  changeLang(String langcode){
    Locale locale = Locale(langcode) ;
    //myServices.sharedPreferences.setString("lang", langcode) ;
    SharedPreference.setLangue(langcode);
    Get.updateLocale(locale) ;
  }

  @override
  void onInit() {
    String? sharedPrefLang = SharedPreference.getLangue();
    if (sharedPrefLang == "fr"){
      language = const Locale("fr")  ;
    }else if (sharedPrefLang == "en"){
      language = const Locale("en")  ;
    }else {
      language = Locale(Get.deviceLocale!.languageCode) ;
    }
    super.onInit();
  }
}