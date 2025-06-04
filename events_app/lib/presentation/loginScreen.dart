import 'package:events_app/presentation/dashboard_screen.dart';
import 'package:events_app/presentation/selectLocation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm import để lưu access token

import '../service/api_service.dart'; // Thêm import ApiService
import '../src/localization/app_vietnamese_strings.dart'; // Import tệp chuỗi tiếng Việt

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppVietnameseStrings.plsEnterEmailPassword)),
      );
      return;
    }

    // Hiển thị dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      // Gọi API để đăng nhập
      final response = await ApiService().requestLogin(email, password);

      // Đóng dialog loading
      Navigator.of(context, rootNavigator: true).pop();

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể kết nối đến server. Vui lòng thử lại sau.')),
        );
        return;
      }

      if (response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'])),
        );
      } else if (response.containsKey('access_token')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token'); // Xóa token cũ trước khi lưu
        await prefs.setString('access_token', response['access_token']);

        // Chuyển đến màn hình chọn vị trí
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectLocation()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thất bại. Vui lòng kiểm tra lại thông tin.')),
        );
      }
    } catch (e) {
      // Đóng dialog loading nếu có lỗi
      if (Navigator.canPop(context)) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Có lỗi xảy ra: $e')),
      );
    }
  }

  void _continueWithoutLogin() async {
    // Xóa access_token nếu có
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    // Chuyển đến màn hình chọn vị trí mà không cần đăng nhập
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                AppVietnameseStrings.welcomeBack,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 175),

              // Email Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppVietnameseStrings.emailAddress,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7C7C7C),
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: AppVietnameseStrings.emailHint,
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFC0BCBC),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Password Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AppVietnameseStrings.password,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7C7C7C),
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: AppVietnameseStrings.enterYourPasswordHint,
                      hintStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFC0BCBC),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF2F2F2)),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF7C7C7C),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 175),

              // Nút đăng nhập
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login, // Gọi hàm _login khi nhấn nút
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0DCDAA),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    AppVietnameseStrings.signIn,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // Thêm nút TextButton cho phép dùng mà không cần đăng nhập
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: _continueWithoutLogin,
                  child: const Text(
                    'Tiếp tục mà không cần đăng nhập',
                    style: TextStyle(
                      color: Color(0xFF0DCDAA),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
