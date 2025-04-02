import 'package:events_app/presentation/selectLocation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Thêm import để lưu access token

import '../service/api_service.dart'; // Thêm import ApiService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  bool _passwordVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
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

      if (response != null && response.containsKey('error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'])),
        );
      } else {
        // Chỉ lưu access token nếu Remember me được chọn
        if (rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('access_token'); // Xóa token cũ trước khi lưu
          await prefs.setString('access_token', response?['access_token']);
        }

        // Chuyển đến màn hình chọn vị trí
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SelectLocation()),
        );
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop(); // Đóng dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Có lỗi xảy ra, vui lòng thử lại')),
      );
    }
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
                'Welcome Back!',
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
                    'Email adress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7C7C7C),
                    ),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'name@example.com',
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
                    'Password',
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
                      hintText: 'Enter your password',
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

              const SizedBox(height: 30),

              // Remember me
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Remember me',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF7C7C7C),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        rememberMe = !rememberMe;
                      });
                    },
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF7C7C7C),
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: rememberMe
                          ? const Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 175),

              // Sign in button
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
                    'Sign in',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
