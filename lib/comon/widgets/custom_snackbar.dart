import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_toast.dart';

void showCustomSnackBar(String? message, {bool isError = true, bool getXSnackBar = false}) {
  if(message != null && message.isNotEmpty) {
    if(getXSnackBar) {
      Get.showSnackbar(GetSnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        message: message,
        maxWidth: 500,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.only(left: 5, right:  5, bottom:  100),
        borderRadius: 5,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      ));
    }else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        dismissDirection: DismissDirection.endToStart,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        content: CustomToast(text: message, isError: isError),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }
}