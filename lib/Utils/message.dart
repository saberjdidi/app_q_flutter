import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_colors.dart';

class Message {
  static void taskErrorOrWarning(String message, String nameErrorOrWarning){
    Get.snackbar(message, nameErrorOrWarning,
        backgroundColor: CustomColors.blueAccent,
        titleText: Text(
          message,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent
          ),
        ),
        messageText: Text(
          nameErrorOrWarning,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber
          ),
        )
    );
  }
}