import 'package:events_app/app_utils.dart';
import 'package:events_app/presentation/home_screen.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../widgets.dart';

class SelectLocationScreen extends StatelessWidget {
  SelectLocationScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
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
                    Text("Most Searched", style: CustomTextStyles.bodySmallGray600_1),
                    SizedBox(height: 20.h),
                            _buildLocationText(context, "Barcelona", "Spain"),
        _buildLocationText(context, "Madrid", "Spain"),
        _buildLocationText(context, "London", "United Kingdom"),
        _buildLocationText(context, "Berlin", "Germany"),
        _buildLocationText(context, "Rome", "Italy"),
        _buildLocationText(context, "Milan", "Italy"),
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

  /// **Search Box with Icon**
//  Widget _buildLocationSelectionRow(BuildContext context) {
//   return Expanded( // ✅ Prevents the Row from overflowing
//     child: CustomSearchView(
//       controller: searchController,
//       hintText: "Select location....",
//       alignment: Alignment.center,
//       contentPadding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.h),
//     ),
//   );
// }


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


//   Widget _buildLocationText(BuildContext context, String city, String country) {
//   return GestureDetector(
//     onTap: () {
//       _navigateToHome(context, city);
//     },
//     child: Padding(
//       padding: EdgeInsets.only(bottom: 20.h),
//       child: SizedBox(
//         width: double.infinity, 
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(city, style: CustomTextStyles.titleMediumGray900, 
//                 overflow: TextOverflow.ellipsis, maxLines: 1), // ✅ Ensures no overflow
//             SizedBox(height: 4.h),
//             Text(country, style: theme.textTheme.bodyLarge, 
//                 overflow: TextOverflow.ellipsis, maxLines: 1), // ✅ Ensures no overflow
//           ],
//         ),
//       ),
//     ),
//   );
// }

Widget _buildLocationText(BuildContext context, String city, String country) {
  return GestureDetector(
    onTap: () {
      _navigateToHome(context, city);
    },
    child: Container( // ✅ Use Container instead of SizedBox for better control
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(city, 
              style: CustomTextStyles.titleMediumGray900, 
              overflow: TextOverflow.ellipsis, 
              maxLines: 1),
          SizedBox(height: 4.h),
          Text(country, 
              style: theme.textTheme.bodyLarge, 
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
      builder: (context) => HomeScreen(selectedLocation: location),
    ),
  );
}

}
