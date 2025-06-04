import 'package:events_app/app_utils.dart';
import 'package:events_app/presentation/update_info_screen.dart';
import 'package:events_app/utils/auth_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  bool isCopyEvent = false;
  // Khai báo biến chứa thông tin user
  String userName = '';
  String userEmail = '';
  String avatar = '';

  // Thêm biến này để lưu location
  String selectedLocation = '';

  @override
  void initState() {
    super.initState();
    _loadSelectedLocation();
    AuthUtils.checkLogin(context);
    _getUserInfo(); // Gọi lấy thông tin user khi widget khởi tạo
  }

  Future<void> _loadSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLocation = prefs.getString('selectedLocation');
    setState(() {
      selectedLocation = storedLocation != null && storedLocation.isNotEmpty
          ? storedLocation
          : 'Hà Nội'; // Giá trị mặc định nếu chưa có trong prefs
    });
  }

  void refreshData() {
    setState(() {
      // Gọi lại các hàm load dữ liệu
      _getUserInfo();
    });
  }

  Future<void> _getUserInfo() async {
    final response =
        await ApiService.requestGetApi('oauth/user/get', useAuth: true);

    if (response != null) {
      setState(() {
        userName = response['full_name'] ?? '';
        userEmail = response['email'] ?? '';
        avatar = response['avatar'] ?? '';
      });
    } else {
      print(AppVietnameseStrings.errorNoValidUserData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 12.h, right: 12.h, top: 26.h),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 4.h),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 110.h,
                        width: 106.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.network(
                              'http://162.248.102.236:8055/assets/$avatar',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => CustomImageView(
                                imagePath: 'assets/images/no_avatar.png',
                                width: double.maxFinite,
                                height: 120.h,
                                fit: BoxFit.cover,
                                radius: BorderRadius.circular(52.h),
                              ),
                            ),
                            CustomIconButton(
                              onTap: () async {
                                String? pickedFile =
                                    await AppUtils.pickImageFromGallery(
                                        context);

                                if (pickedFile.isEmpty) {
                                  debugPrint(
                                      AppVietnameseStrings.errorNoFileSelected);
                                  return;
                                }

                                debugPrint(
                                    '${AppVietnameseStrings.pickedFilePathDebug}$pickedFile');

                                final apiService = ApiService();
                                final Map<String, dynamic>? response =
                                    await apiService.updateAvatar(pickedFile);

                                if (response != null &&
                                    response.containsKey('data') &&
                                    response['data'].containsKey('avatar')) {
                                  setState(() {
                                    avatar = response['data']['avatar'];
                                  });
                                } else {
                                  debugPrint(AppVietnameseStrings
                                      .errorFailedToUploadImage);
                                }
                              },
                              height: 48.h,
                              width: 48.h,
                              padding: EdgeInsets.all(8.h),
                              decoration: IconButtonStyleHelper.none,
                              alignment: Alignment.bottomRight,
                              child: const CustomImageView(
                                imagePath: 'assets/images/edit_icon.png',
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 22.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(userName,
                              style: CustomTextStyles.titleMediumSemiBold),
                          SizedBox(width: 4.h),
                          CustomIconButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdateInfoScreen(),
                                ),
                              );
                            },
                            height: 20.h,
                            width: 20.h,
                            child: Icon(Icons.edit, size: 20.h),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(userEmail,
                          style: CustomTextStyles.bodySmallBlack900),
                      SizedBox(height: 76.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.h),
                          child: Text(AppVietnameseStrings.settingsTitle,
                              style: CustomTextStyles.titleMediumSemiBold),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _buildPrimaryCityTab(context),
                      _buildCopyEventTab(context),
                      // _buildManageEventsTab(context),
                      _buildLoginOptionsTab(context),
                      _buildAccountSettingsTab(context),
                    ],
                  ),
                ),
                const Spacer(),
                CustomOutlinedButton(
                  text: AppVietnameseStrings.logOutButton,
                  onPressed: () {
                    AppUtils.showConfirmDialog(
                      context,
                      AppVietnameseStrings.confirmLogOutMessage,
                      onConfirm: () {
                        AppUtils.logout(context);
                      },
                    );
                  },
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.h),
                    border: Border.all(color: appTheme.gray600),
                  ),
                  buttonTextStyle: CustomTextStyles.titleMediumGray600,
                ),
                SizedBox(height: 88.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryCityTab(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      padding: EdgeInsets.all(12.h),
      decoration: AppDecoration.globalGreylight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 8.h, top: 2.h),
              child: Text(AppVietnameseStrings.primaryCityLabel,
                  style: CustomTextStyles.bodySmallBlack900),
            ),
          ),
          Text(selectedLocation ?? 'Hà Nội',
              style: CustomTextStyles.bodySmallBlack900),
        ],
      ),
    );
  }

  Widget _buildCopyEventTab(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 10.h),
      decoration: AppDecoration.globalGreylight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 2.h),
              child: Text(AppVietnameseStrings.copyEventToCalendarLabel,
                  style: CustomTextStyles.bodySmallBlack900),
            ),
          ),
          CustomSwitch(
            value: isCopyEvent,
            onChange: (value) {
              setState(() {
                isCopyEvent = value;
              });
            },
          )
        ],
      ),
    );
  }

  // Widget _buildManageEventsTab(BuildContext context) {
  //   return Container(
  //     width: double.maxFinite,
  //     margin: EdgeInsets.symmetric(horizontal: 4.h),
  //     padding: EdgeInsets.all(10.h),
  //     decoration: AppDecoration.globalGreylight,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Align(
  //           alignment: Alignment.bottomCenter,
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 8.h),
  //             child: Text('Tùy chỉnh sự kie',
  //                 style: CustomTextStyles.bodySmallBlack900),
  //           ),
  //         ),
  //         Icon(Icons.arrow_forward_ios, size: 20.h)
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLoginOptionsTab(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.globalGreylight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Text('Tùy chọn đăng nhập',
                  style: CustomTextStyles.bodySmallBlack900),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 20.h)
        ],
      ),
    );
  }

  Widget _buildAccountSettingsTab(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 4.h),
      padding: EdgeInsets.all(10.h),
      decoration: AppDecoration.globalGreylight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Text('Cài đặt tài khoản',
                  style: CustomTextStyles.bodySmallBlack900),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 20.h)
        ],
      ),
    );
  }
}
