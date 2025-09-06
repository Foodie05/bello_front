import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastUtil {
  static void showSuccess(
    String message, {
    String? title,
    Duration? autoCloseDuration,
  }) {
    toastification.show(
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      title: Text(title ?? '成功'),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 3),
      showProgressBar: true,
      dragToClose: true,
      backgroundColor: Colors.green.shade50,
      foregroundColor: Colors.green,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.green.shade100,
          blurRadius: 20,
          offset: const Offset(0, 0),
        ),
      ],
      borderSide: BorderSide(color: Colors.green.shade300, width: 1),
    );
  }

  static void showError(
    String message, {
    String? title,
    Duration? autoCloseDuration,
  }) {
    toastification.show(
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      title: Text(title ?? '错误'),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 5),
      showProgressBar: true,
      dragToClose: true,
      backgroundColor: Colors.red.shade50,
      foregroundColor: Colors.red,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.red.shade100,
          blurRadius: 20,
          offset: const Offset(0, 0),
        ),
      ],
      borderSide: BorderSide(color: Colors.red.shade300, width: 1),
    );
  }

  static void showWarning(
    String message, {
    String? title,
    Duration? autoCloseDuration,
  }) {
    toastification.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.minimal,
      title: Text(title ?? '警告'),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 4),
      showProgressBar: true,
      dragToClose: true,
      backgroundColor: Colors.orange.shade50,
      foregroundColor: Colors.orange,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.orange.shade100,
          blurRadius: 20,
          offset: const Offset(0, 0),
        ),
      ],
      borderSide: BorderSide(color: Colors.orange.shade300, width: 1),
    );
  }

  static void showInfo(
    String message, {
    String? title,
    Duration? autoCloseDuration,
  }) {
    toastification.show(
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      title: Text(title ?? '信息'),
      description: Text(message),
      alignment: Alignment.topRight,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 3),
      showProgressBar: true,
      dragToClose: true,
      backgroundColor: Colors.blue.shade50,
      foregroundColor: Colors.blue,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 15,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.blue.shade100,
          blurRadius: 20,
          offset: const Offset(0, 0),
        ),
      ],
      borderSide: BorderSide(color: Colors.blue.shade300, width: 1),
    );
  }
}
