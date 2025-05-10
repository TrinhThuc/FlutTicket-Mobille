import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Hàm để gửi request API
  static Future<dynamic> requestApi(
      String endpoint, Map<String, dynamic> body,
      {bool useAuth = false}) async {
    final url = 'https://a684-14-224-155-46.ngrok-free.app/apis/$endpoint';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept-Language': 'vi-VN',
    };

    if (useAuth) {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      if (accessToken == null || accessToken.isEmpty) {
        print('Error: No access token found');
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
        print('API request $url failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error connecting to API: $e');
    }
  }

  static Future<dynamic> requestGetApi(String endpoint, 
      {bool useAuth = true}) async {
    final url = 'https://a684-14-224-155-46.ngrok-free.app/apis/$endpoint';

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

  Future<Map<String, dynamic>?> requestLogin(
      String username, String password) async {
    final url =
        Uri.parse('https://a684-14-224-155-46.ngrok-free.app/apis/oauth/token');

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

  Future<Map<String, dynamic>?> updateAvatar(String filePath) async {
    final url = Uri.parse(
        'https://a684-14-224-155-46.ngrok-free.app/apis/oauth/user/update-avatar');

    try {
      // Lấy access token từ SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      if (accessToken == null || accessToken.isEmpty) {
        print('Error: No access token found');
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
    String endpoint, Map<String, dynamic> body,
    {bool useAuth = false}) async {
  final url = 'https://a684-14-224-155-46.ngrok-free.app/apis/$endpoint';

  Map<String, String> headers = {
    'Accept-Language': 'vi-VN',
    'Content-Type': 'application/json',
  };

  if (useAuth) {
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');
    if (accessToken == null || accessToken.isEmpty) {
      print('Error: No access token found');
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
  static Future<dynamic> requestGetOder(String endpoint,
      {bool useAuth = true}) async {
    final url = 'https://a684-14-224-155-46.ngrok-free.app/apis/$endpoint';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept-Language': 'vi-VN',
    };

    if (useAuth) {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      if (accessToken == null || accessToken.isEmpty) {
        print('Error: No access token found');
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
