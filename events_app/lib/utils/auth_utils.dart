import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/api_service.dart';

class AuthUtils {
  static Future<bool> checkLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null || token.isEmpty) {
      if (context.mounted) {
        await ApiService.showLoginRequiredDialog(context);
        Navigator.pop(context); // Quay lại màn hình trước
      }
      return false;
    }
    return true;
  }
} 