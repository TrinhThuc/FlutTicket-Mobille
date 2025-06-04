import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../presentation/loginScreen.dart';

Future<void> showLoginRequiredDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Yêu cầu đăng nhập'),
      content: const Text('Bạn cần đăng nhập để sử dụng chức năng này.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Đóng'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: const Text('Đăng nhập'),
        ),
      ],
    ),
  );
}

class AuthUtils {
  static Future<bool> checkLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null || token.isEmpty) {
      if (context.mounted) {
        await showLoginRequiredDialog(context);
        Navigator.pop(context); // Quay lại màn hình trước
      }
      return false;
    }
    return true;
  }
}
