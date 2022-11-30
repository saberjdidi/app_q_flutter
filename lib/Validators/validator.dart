import 'package:get/get.dart';

class Validator {
  /// 1- to handle error in all textfield ///
  static String? validateField({required String value}) {
    if (value.isEmpty) {
      return 'field_not_empty'.tr;
    }

    return null;
  }
}
