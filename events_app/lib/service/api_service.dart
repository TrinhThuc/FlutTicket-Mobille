import 'dart:convert';

import 'package:flutter/services.dart' as rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Hàm để gửi request API
  static Future<dynamic> requestApi(String endpoint, String fakeEndpoint, Map<String, dynamic> body) async {
    final url = 'http://192.168.22.49:8302/$endpoint';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        print('API request failed with status: ${response.statusCode}');
        return await _loadFakeResponse(fakeEndpoint);
      }
    } catch (e) {
      print('Error connecting to API: $e');
      // Nếu không kết nối được đến server, lấy dữ liệu từ response local
      return await _loadFakeResponse(fakeEndpoint);
    }
  }

   static Future<dynamic> requestGetApi(String endpoint, String fakeEndpoint) async {
    final url = 'http://192.168.22.49:8302/$endpoint';

    try {
      // Lấy access token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null || accessToken.isEmpty) {
        print('Error: No access token found');
        return {"error": "Unauthorized"};
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('API request failed with status: ${response.statusCode}');
        return await _loadFakeResponse(fakeEndpoint);
      }
    } catch (e) {
      print('Error connecting to API: $e');
      return await _loadFakeResponse(fakeEndpoint);
    }
  }

  static Future<dynamic> _loadFakeResponse(String fakeEndpoint) async {
    final fakeData = {
      "user": {"name": "John Doe", "email": "john.doe@example.com"}
    };

    print('Returning fake response for: $fakeEndpoint');
    return fakeData;
  }
}

  Future<Map<String, dynamic>?> requestLogin(String username, String password) async {
    final url = Uri.parse('http://192.168.22.49:8302/oauth/token');

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
      final streamedResponse = await request.send().timeout(const Duration(seconds: 5));
      final response = await http.Response.fromStream(streamedResponse).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Giải mã JSON nếu thành công
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Xử lý lỗi, có thể ghi log hoặc ném exception
        print('Lỗi đăng nhập: ${response.statusCode} - ${response.body}');
        return await _loadFakeResponse('login'); // Lấy response local nếu đăng nhập thất bại
      }
    } catch (e) {
      print('Exception: $e');
      return await _loadFakeResponse('login'); // Lấy response local nếu có lỗi
    }
  }

  // Hàm để lấy fake response từ file
  static Future<dynamic> _loadFakeResponse(String fakeEndpoint) async {
    try {
      final response = await rootBundle.rootBundle.loadString('assets/response-api/$fakeEndpoint.json');
      final data = json.decode(response);
      print('Fake response loaded successfully: $data');
      return data; 
    } catch (e) {
      print('Error loading fake response: $e');
      return {}; // Trả về object trống thay vì null
    }
  }
}