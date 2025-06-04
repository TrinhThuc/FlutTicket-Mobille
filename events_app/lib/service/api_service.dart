import 'dart:convert';
import 'dart:developer';

import 'package:events_app/presentation/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Hàm hiển thị dialog yêu cầu đăng nhập
  static Future<void> showLoginRequiredDialog(BuildContext context) async {
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

  // Hàm để gửi request API
  static Future<dynamic> requestApi(
    String endpoint,
    dynamic body, {
    bool useAuth = false,
    BuildContext? context,
  }) async {
    final url = 'http://192.168.0.104:8301/$endpoint';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept-Language': 'vi-VN',
    };

    if (useAuth) {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      if (accessToken == null || accessToken.isEmpty) {
        print('Error: No access token found');
        if (context != null) {
          await showLoginRequiredDialog(context);
        }
        return null;
      }
      headers['Authorization'] = 'Bearer $accessToken';
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API request $url failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error connecting to API: $e');
      return null;
    }
  }

  static Future<dynamic> requestGetApi(
    String endpoint, {
    bool useAuth = false,
    BuildContext? context,
  }) async {
    final url = 'http://192.168.0.104:8301/$endpoint';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept-Language': 'vi-VN',
    };

    if (useAuth) {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      log('Access token: $accessToken');
      if (accessToken == null || accessToken.isEmpty) {
        print('Error: No access token found');
        if (context != null) {
          await showLoginRequiredDialog(context);
        }
        return null;
      }
      headers['Authorization'] = 'Bearer $accessToken';
    }

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API request $url failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error connecting to API: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> requestLogin(
      String username, String password) async {
    final url = Uri.parse('http://192.168.0.104:8301/oauth/token');

    // Tạo request dạng Multipart để gửi dữ liệu form-data
    final request = http.MultipartRequest('POST', url)
      ..headers['Accept-Language'] = 'vi-VN'
      ..headers['Authorization'] =
          'Basic YXV0aG9yaXphdGlvbl9jbGllbnRfaWQ6YmNjczM=';

    // Thêm các trường dữ liệu vào body (form-data)
    request.fields['grant_type'] = 'password';
    request.fields['username'] = username;
    request.fields['password'] = password;

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        // Giải mã JSON nếu thành công
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Xử lý lỗi, có thể ghi log hoặc ném exception
        print('Lỗi đăng nhập: ${response.statusCode} - ${response.body}');
        // return await _loadFakeResponse('login'); // Lấy response local nếu đăng nhập thất bại
      }
    } catch (e) {
      print('Exception: $e');
      // return await _loadFakeResponse('login'); // Lấy response local nếu có lỗi
    }
    return null;
  }

  Future<Map<String, dynamic>?> updateAvatar(String filePath,
      {BuildContext? context}) async {
    final url = Uri.parse('http://192.168.0.104:8301/oauth/user/update-avatar');

    try {
      // Lấy access token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null || accessToken.isEmpty) {
        print('Error: No access token found');
        if (context != null) {
          await showLoginRequiredDialog(context);
        }
        return {"error": "Unauthorized"};
      }

      // Tạo request dạng Multipart để gửi file
      final request = http.MultipartRequest('POST', url)
        ..headers['Accept-Language'] = 'vi-VN'
        ..headers['Authorization'] = 'Bearer $accessToken';

      // Thêm file vào request
      request.files.add(await http.MultipartFile.fromPath('avatar', filePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print(
            'Error updating avatar: ${response.statusCode} - ${response.body}');
        return {"error": "Failed to update avatar"};
      }
    } catch (e) {
      print('Exception: $e');
      // return await _loadFakeResponse('update-avatar'); // Lấy response local nếu có lỗi
    }
    return null;
  }

  static Future<dynamic> requestPostOder(
    String endpoint,
    Map<String, dynamic> body, {
    bool useAuth = false,
    BuildContext? context,
  }) async {
    final url = 'http://192.168.0.104:8301/$endpoint';

    Map<String, String> headers = {
      'Accept-Language': 'vi-VN',
      'Content-Type': 'application/json',
    };

    if (useAuth) {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      if (accessToken == null || accessToken.isEmpty) {
        print('Error: No access token found');
        if (context != null) {
          await showLoginRequiredDialog(context);
        }
        return {"error": "Unauthorized"};
      }
      headers['Authorization'] = 'Bearer $accessToken';
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // 🔥 Quan trọng: cần return lỗi luôn nếu không phải 200
        return json.decode(response.body);
      }
    } catch (e) {
      print('Error connecting to API: $e');
      return {"error": "Connection failed", "exception": e.toString()};
    }
  }

  // hàm get oder
  static Future<dynamic> requestGetOder(
    String endpoint, {
    bool useAuth = true,
    BuildContext? context,
  }) async {
    final url = 'http://192.168.0.104:8301/$endpoint';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept-Language': 'vi-VN',
    };

    if (useAuth) {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      if (accessToken == null || accessToken.isEmpty) {
        print('Error: No access token found');
        if (context != null) {
          await showLoginRequiredDialog(context);
        }
        return {"error": "Unauthorized"};
      }
      headers['Authorization'] = 'Bearer $accessToken';
    }

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API request $url failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error connecting to API: $e');
    }
  }
}
