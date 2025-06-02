import 'package:flutter/material.dart';

import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart';
import 'loginScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignupscreenState createState() => _SignupscreenState();
}

class _SignupscreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      Navigator.of(context).pop(); // Đóng dialog nếu đang mở
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppVietnameseStrings.passwordsDoNotMatch)),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    try {
      final body = {
        'requests': [
          {
        'username': _emailController.text,
        'email': _emailController.text,
        'fullName': _nameController.text,
        'password': _passwordController.text,
          }]
      };

      final response = await ApiService.requestApi(
          'oauth/user/register',  body);

      if (response.containsKey('error')) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop(); // Đóng dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['error'])),
          );
        }
      } else {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop(); // Đóng dialog sử dụng root navigator
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
        }
      }
    } catch (e) {
      print('Lỗi đăng ký: $e');
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // Đóng dialog trong trường hợp exception
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppVietnameseStrings.errorOccurredPleaseTryAgain)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 76),
                // Back button and title
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 26),
                    const Text(
                      AppVietnameseStrings.createNewAccount,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 114),
                // Input fields
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInputField(
                      label: AppVietnameseStrings.fullName,
                      hint: AppVietnameseStrings.enterYourNameHint,
                      controller: _nameController,
                    ),
                    const SizedBox(height: 30),
                    _buildInputField(
                      label: AppVietnameseStrings.emailAddress,
                      hint: AppVietnameseStrings.emailHint,
                      controller: _emailController,
                    ),
                    const SizedBox(height: 30),
                    _buildInputField(
                      label: AppVietnameseStrings.createPassword,
                      hint: AppVietnameseStrings.enterYourPasswordHint,
                      controller: _passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 30),
                    _buildInputField(
                      label: AppVietnameseStrings.repeatPassword,
                      hint: AppVietnameseStrings.repeatNewPasswordHint,
                      controller: _confirmPasswordController,
                      isPassword: true,
                    ),
                  ],
                ),
                // const Spacer(),
                const SizedBox(height: 30),
                // Sign up button
                Padding(
                  padding: const EdgeInsets.only(bottom: 76),
                  child: ElevatedButton(
                    onPressed: () {
                      signUp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0DCDAA),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      AppVietnameseStrings.signUp,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
            color: Color(0xFF7C7C7C),
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
              color: Color(0xFFC0BCBC),
            ),
            border: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFF2F2F2),
                width: 1,
              ),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFF2F2F2),
                width: 1,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF0DCDAA),
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
