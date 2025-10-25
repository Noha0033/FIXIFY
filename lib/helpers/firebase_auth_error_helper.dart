import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthErrorHelper {
  static String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'صيغة البريد الإلكتروني غير صحيحة.';
      case 'user-disabled':
        return 'هذا الحساب تم تعطيله.';
      case 'user-not-found':
        return 'البريد غير مسجل. يرجى إنشاء حساب جديد.';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة.';
      case 'email-already-in-use':
        return 'هذا البريد الإلكتروني مستخدم بالفعل.';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جدًا.';
      case 'too-many-requests':
        return 'محاولات كثيرة جدًا. حاول لاحقًا.';
      case 'network-request-failed':
        return 'تحقق من اتصالك بالإنترنت.';
      case 'invalid-credential':
      case 'invalid-verification-code':
      case 'invalid-verification-id':
        return 'بيانات الدخول غير صالحة أو انتهت صلاحيتها.';
      default:
        return 'حدث خطأ غير متوقع. حاول مرة أخرى.';
    }
  }

  /// 🔹 إظهار Dialog منسق بالرسالة العربية
  static void showErrorDialog(BuildContext context, FirebaseAuthException e) {
    final message = _getErrorMessage(e.code);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.error_outline, color: Colors.redAccent),
            SizedBox(width: 8),
            Text(
              'خطأ في تسجيل الدخول',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  /// 🔹 أو خيار ثاني: SnackBar مخصص بدلاً من Dialog
  static void showSnackBar(BuildContext context, FirebaseAuthException e) {
    final message = _getErrorMessage(e.code);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 15, color: Colors.white),
                textDirection: TextDirection.rtl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
