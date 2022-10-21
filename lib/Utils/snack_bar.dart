import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowSnackBar {
  static void snackBar(String title, String message, Color backgroundColor) {
    Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor,
        colorText: Colors.white
    );
  }
}