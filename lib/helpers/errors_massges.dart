import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class ErrorHelper {
  static Future<T?> handle<T>({
    required BuildContext context,
    required Future<T> Function() action,
    bool showDialog = false,
  }) async {
    try {
      // تنفيذ العملية
      return await action();
    } on SocketException {
      _showError(context, 'تأكد من اتصالك بالإنترنت 🔌', showDialog);
    } on TimeoutException {
      _showError(context, 'انتهى وقت الطلب، حاول مجددًا ⏳', showDialog);
    } on FormatException {
      _showError(context, 'البيانات غير صالحة 📄', showDialog);
    } on HttpException {
      _showError(context, 'حدث خطأ من الخادم ⚠️', showDialog);
    } catch (e) {
      _showError(context, 'حدث خطأ غير متوقع ❌\n${e.toString()}', showDialog);
    }
    return null;
  }

  /// دالة لعرض الرسالة للمستخدم
  static void _showError(BuildContext context, String message, bool dialog) {
    if (dialog) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('خطأ'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('موافق'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }
}
