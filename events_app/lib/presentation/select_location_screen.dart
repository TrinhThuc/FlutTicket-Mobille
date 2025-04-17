import 'package:events_app/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../widgets.dart';
import 'dashboard_screen.dart';

class SelectLocationScreen extends StatelessWidget {
  SelectLocationScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            // _buildHeader(),
            SizedBox(height: 20.h),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 18.h),
                decoration: AppDecoration.globalWhite.copyWith(
                  borderRadius: BorderRadiusStyle.customBorderTL30,
                ),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _buildLocationSelectionRow(context),
                    SizedBox(height: 34.h),
                    Text("Most Searched",
                        style: CustomTextStyles.bodySmallGray600_1),
                    SizedBox(height: 20.h),
                    _buildLocationText(context, "Hà Nội"),
                    _buildLocationText(context, "TP Hồ Chí Minh"),
                    _buildLocationText(context, "Đà Nẵng"),
                    _buildLocationText(context, "Huế"),
                    _buildLocationText(context, "Đà Lạt"),
                    _buildLocationText(context, "Hội An"),
                    _buildLocationText(context, "Hưng Yên"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Header Section with Title & Subtitle**
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(left: 20.h, top: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Hello!", style: theme.textTheme.headlineSmall),
          SizedBox(height: 10.h),
          Text(
            "Let's find your next event. \nChoose a location.",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodyLargeGray600.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelectionRow(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: CustomSearchView(
        controller: searchController,
        hintText: "Select location....",
        alignment: Alignment.center,
        contentPadding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.h),
      ),
    );
  }

  Widget _buildLocationText(BuildContext context, String city) {
    return GestureDetector(
      onTap: () async {
        await SharedPreferences.getInstance().then((prefs) async {
          await prefs.remove('selectedLocation'); // Xóa token cũ trước khi lưu

          prefs.setString('selectedLocation', city);
        });
        _navigateToHome(context, city);
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(city,
                style: CustomTextStyles.titleMediumGray900,
                overflow: TextOverflow.ellipsis,
                maxLines: 1),
          ],
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context, String location) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ),
    );
  }
}
