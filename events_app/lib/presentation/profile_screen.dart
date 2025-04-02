import 'package:events_app/app_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  bool isCopyEvent = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          CustomImageView(
                            imagePath: 'assets/images/avatar.png',
                            width: 104.h,
                            height: 104.h,
                            radius: BorderRadius.circular(52.h),
                          ),
                          CustomIconButton(
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
                        Text('Thực',
                            style: CustomTextStyles.titleMediumSemiBold),
                        SizedBox(width: 4.h),
                        Icon(Icons.edit, size: 20.h),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text('info@youremail.com',
                        style: CustomTextStyles.bodySmallBlack900),
                    SizedBox(height: 76.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: EdgeInsets.only(left: 4.h),
                          child: Text('Settings',
                              style: CustomTextStyles.titleMediumSemiBold)),
                    ),
                    SizedBox(height: 10.h),
                    _buildPrimaryCityTab(context),
                    _buildCopyEventTab(context),
                    _buildManageEventsTab(context),
                    _buildLoginOptionsTab(context),
                    _buildAccountSettingsTab(context),
                    // SizedBox(height: 176.h),
                    
                  ],
                ),
              ),
              const Spacer(),
              CustomOutlinedButton(
                      text: 'Log Out',
                      onPressed: () {},
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
      )),
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
              child: Text('Primary City',
                  style: CustomTextStyles.bodySmallBlack900),
            ),
          ),
          Text(
            'Barcelona',
            style: CustomTextStyles.bodySmallBlack900,
          )
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
              child: Text('Copy Event to calendar',
                  style: CustomTextStyles.bodySmallBlack900),
            ),
          ),
          CustomSwitch(
            value: isCopyEvent,
            onChange: (value) {
              isCopyEvent = value;
            },
          )
        ],
      ),
    );
  }

  Widget _buildManageEventsTab(BuildContext context) {
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
              child: Text('Manage Events',
                  style: CustomTextStyles.bodySmallBlack900),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 20.h)
        ],
      ),
    );
  }

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
              child: Text('Manage Log in options',
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
              child: Text('Account Settings',
                  style: CustomTextStyles.bodySmallBlack900),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 20.h)
        ],
      ),
    );
  }
}
