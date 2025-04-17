import 'package:events_app/constants/colors.dart';
import 'package:events_app/constants/styles.dart';
import 'package:events_app/constants/values.dart';
import 'package:events_app/presentation/dashboard_screen.dart';
import 'package:events_app/widgets/button_widget.dart';
import 'package:events_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

import '../service/api_service.dart';

class UpdateInfoScreen extends StatefulWidget {
  const UpdateInfoScreen({super.key});

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  int _selectedGender = 0;
  bool _isLoading = true;

  void initState() {
    super.initState();
    _getUserInfo(); // Gọi lấy thông tin user khi widget khởi tạo
  }

  Future<void> _getUserInfo() async {
    final response =
        await ApiService.requestGetApi('oauth/user/get', useAuth: true);

    if (response != null) {
      setState(() {
        _fullNameController.text = response['full_name'] ?? '';
        _phoneController.text = response['phone'] ?? '';
        _locationController.text = response['location'] ?? '';
        // Giới tính: từ số -> chuỗi
        // final int genderCode = response['gender'] ?? -1;
        // if (genderCode == 0) {
        //   selectedGender = 'Nam';
        // } else if (genderCode == 1) {
        //   selectedGender = 'Nữ';
        // } else {
        //   selectedGender = 'Khác';
        // }
        // // Giới tính: từ chuỗi -> số
        // if (selectedGender == 'Nam') {
        //   _selectedGender = 0;
        // } else if (selectedGender == 'Nữ') {
        //   _selectedGender = 1;
        // } else {
        //   _selectedGender = -1; // Hoặc giá trị mặc định khác
        // }
        _selectedGender = response['gender'] ?? -1;
        _isLoading = false;
      });
    } else {
      print('Lỗi: Không nhận được dữ liệu user hợp lệ');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _fullNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  _isLoading
    ? const Center(child: CircularProgressIndicator())
    : Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Cập nhật thông tin',
          style: AppStyles.h2.copyWith(color: AppColors.text),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppValues.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Số điện thoại',
              style: AppStyles.h3.copyWith(color: AppColors.text),
            ),
            const SizedBox(height: AppValues.spacing),
            TextFieldWidget(
              controller: _phoneController,
              hintText: 'Nhập số điện thoại',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: AppValues.spacing * 2),
            Text(
              'Họ và tên',
              style: AppStyles.h3.copyWith(color: AppColors.text),
            ),
            const SizedBox(height: AppValues.spacing),
            TextFieldWidget(
              controller: _fullNameController,
              hintText: 'Nhập họ và tên',
            ),
            const SizedBox(height: AppValues.spacing * 2),
            Text(
              'Địa chỉ',
              style: AppStyles.h3.copyWith(color: AppColors.text),
            ),
            const SizedBox(height: AppValues.spacing),
            TextFieldWidget(
              controller: _locationController,
              hintText: 'Nhập địa chỉ',
            ),
            const SizedBox(height: AppValues.spacing * 2),
            Text(
              'Giới tính',
              style: AppStyles.h3.copyWith(color: AppColors.text),
            ),
            const SizedBox(height: AppValues.spacing),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    title: const Text('Nam', style: AppStyles.h4),
                    value: 0,
                    groupValue: _selectedGender ?? 0,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value ?? _selectedGender;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    title: const Text('Nữ', style: AppStyles.h4),
                    value: 1,
                    groupValue: _selectedGender ?? 0,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value ?? _selectedGender;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppValues.spacing * 3),
            ButtonWidget(
              text: 'Cập nhật',
              onPressed: () {
                final updateData = {
                  "phone": _phoneController.text,
                  "fullName": _fullNameController.text,
                  "location": _locationController.text,
                  "gender": _selectedGender
                };
                print(updateData);
                ApiService.requestApi('oauth/user/update-info', updateData,
                        useAuth: true)
                    .then((response) {
                  if (response != null &&
                      response['status']['success'] == true) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(),
                      ),
                    );
                  } else {
                    print('Lỗi: Cập nhật thông tin không thành công');
                  }
                }).catchError((error) {
                  print('Lỗi: $error');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
