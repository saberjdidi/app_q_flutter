class Validator {
  /// 1- to handle error in all textfield ///
  static String? validateField({required String value}) {
    if (value.isEmpty) {
      return 'Field can\'t be empty';
    }

    return null;
  }

}
