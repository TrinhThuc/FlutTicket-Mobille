import 'package:events_app/constants/colors.dart';
import 'package:events_app/constants/styles.dart';
import 'package:events_app/constants/values.dart';
import 'package:events_app/presentation/dashboard_screen.dart';
import 'package:events_app/widgets/button_widget.dart';
import 'package:events_app/widgets/text_field_widget.dart';
import 'package:flutter/material.dart';

import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart';
import 'profile_screen.dart';

void hideLoadingDialog(BuildContext context) {
  Navigator.of(context, rootNavigator: true).pop();
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

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
      print(AppVietnameseStrings.errorNoValidUserData);
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              title: Text(
                AppVietnameseStrings.updateInfoTitle,
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
                    AppVietnameseStrings.phoneNumberLabel,
                    style: AppStyles.h3.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppValues.spacing),
                  TextFieldWidget(
                    controller: _phoneController,
                    hintText: AppVietnameseStrings.enterPhoneNumberHint,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: AppValues.spacing * 2),
                  Text(
                    AppVietnameseStrings.fullName,
                    style: AppStyles.h3.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppValues.spacing),
                  TextFieldWidget(
                    controller: _fullNameController,
                    hintText: AppVietnameseStrings.enterYourNameHint,
                  ),
                  const SizedBox(height: AppValues.spacing * 2),
                  Text(
                    AppVietnameseStrings.addressLabel,
                    style: AppStyles.h3.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppValues.spacing),
                  TextFieldWidget(
                    controller: _locationController,
                    hintText: AppVietnameseStrings.enterAddressHint,
                  ),
                  const SizedBox(height: AppValues.spacing * 2),
                  Text(
                    AppVietnameseStrings.genderLabel,
                    style: AppStyles.h3.copyWith(color: AppColors.text),
                  ),
                  const SizedBox(height: AppValues.spacing),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<int>(
                          title: const Text(AppVietnameseStrings.male,
                              style: AppStyles.h4),
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
                          title: const Text(AppVietnameseStrings.female,
                              style: AppStyles.h4),
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
                    text: AppVietnameseStrings.updateButton,
                    onPressed: () {
                      final updateData = {
                        "phone": _phoneController.text,
                        "fullName": _fullNameController.text,
                        "location": _locationController.text,
                        "gender": _selectedGender
                      };
                      print(updateData);
                      showLoadingDialog(context);
                      ApiService.requestApi(
                              'oauth/user/update-info', updateData,
                              useAuth: true)
                          .then((response) {
                        if (response != null &&
                            response['status']['success'] == true) {
                          hideLoadingDialog(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        } else {
                          print(AppVietnameseStrings.errorUpdateInfoFailed);
                        }
                      }).catchError((error) {
                        print('${AppVietnameseStrings.errorPrefix}: $error');
                      });
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
