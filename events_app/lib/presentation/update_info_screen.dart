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

  @override
  void dispose() {
    _phoneController.dispose();
    _fullNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    title: Text('Nam', style: AppStyles.h4),
                    value: 0,
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value ?? _selectedGender;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    title: Text('Nữ', style: AppStyles.h4),
                    value: 1,
                    groupValue: _selectedGender,
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
                ApiService.requestApi(
                        'oauth/user/update-info',updateData, useAuth: true)
                    .then((response) {
                  if (response != null && response['status']['success'] == true) {
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
