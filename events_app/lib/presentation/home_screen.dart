import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../app_theme.dart';
import '../app_utils.dart';
import '../widgets.dart';
import 'single_event_screen.dart';

class HomeScreen extends StatelessWidget {
  final String selectedLocation;

  HomeScreen({super.key, required this.selectedLocation});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: HomeInitialPage( ),
      ),
    );
  }
}

/// **Home Initial Page with Events**
class EventlistItemWidget extends StatelessWidget {
  const EventlistItemWidget( {super.key, required this.index});
final int index;
  @override
  Widget build(BuildContext context) {
    int index = this.index;
    return SizedBox(
      height: 96.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    CustomImageView(
                      imagePath: "assets/images/Rectangle_4.png",
                      height: 84.h,
                      width: 88.h,
                      radius: BorderRadius.circular(
                        10.h,
                      ),
                    ),
                    
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              style: theme.textTheme.bodySmall,
                              "Thu, Apr 19 20.00 Pm",
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "The Kooks",
                              style: CustomTextStyles.titleMediumGray900_1,
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: double.maxFinite,
                              child: Row(
                                children: [
                    
                                  Icon(
                                    Icons.location_on_outlined,
                                    color: appTheme.gray900,
                                    size: 14.h,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 4.h),
                                    child: Text(
                                      "Razzmatazz",
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    Icon(
                      Icons.favorite_border_outlined,
                      color: appTheme.gray900,
                      size: 18.h,
                    ),
                    
                    Icon(
                      Icons.share_outlined,
                      color: appTheme.gray900,
                      size: 18.h,
                    ),
                  ],
                ),
              ),
            ],
          ),

         index == 0?
              
              
          CustomElevatedButton(
            height: 26.h,
            width: 36.h,
            text: "New",
            margin: EdgeInsets.only(left: 46.h),
            buttonStyle: CustomButtonStyles.fillGreenA,
            buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
            alignment: Alignment.topLeft,
          ): SizedBox(),
            
        ],
      ),
    );
  }
}

class HomeInitialPage extends StatefulWidget {
  const HomeInitialPage({super.key});
  @override
  _HomeInitialPageState createState() => _HomeInitialPageState();
}

class _HomeInitialPageState extends State<HomeInitialPage> {
  List<String> dropdownItemsList = ["Item 1", "Item 2", "Item 3"];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.fillwhiteA,
      child: Column(
        children: [
          SizedBox(
            width: double.maxFinite,
            child: _buildAppBar(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.h,
                  vertical: 20.h,
                ),
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Popular in Barcelona",
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: 14.h),
                    _buildEventTile(context),
                    SizedBox(height: 14.h),
                    _buildEventList(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      height: 56.h,
      title: Padding(
        padding: EdgeInsets.only(left: 24.h, top: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            AppbarSubtitle(
              text: "Find events in",
              margin: EdgeInsets.only(right: 49.h),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon (
                  Icons.location_on_outlined,
                  color: appTheme.gray900,
                ),
                AppbarTitleDropdown(
                  margin: EdgeInsets.only(left: 3.h),
                  hintText: "Barcelona",
                  items: dropdownItemsList,
                  onTap: (value) {},
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventTile(BuildContext context) {
    return GestureDetector(
       onTap: () {
      _navigateToEventPage(context, "La Rosalia", "Mon, Apr 18 21:00 Pm", "Palau Sant Jordi, Barcelona", "assets/images/Rectangle_3.png");
    },
      child: Container(
        width: double.maxFinite,
        decoration: AppDecoration.globalGrey.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120.h,
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomImageView(
                    imagePath: "assets/images/Rectangle_3.png",
                    
                    height: 120.h,
                    width: double.maxFinite,
                    radius: BorderRadius.vertical(
                      top: Radius.circular(10.h),
                    ),
                  ),
                  CustomElevatedButton(
                    height: 26.h,
                    width: 38.h,
                    text: "New",
                    margin: EdgeInsets.only(
                      top: 8.h,
                      right: 8.h,
                    ),
                    buttonStyle: CustomButtonStyles.fillGreenA,
                    buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
                    alignment: Alignment.topRight,
                  ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Text(
                "Mon, Apr 18 21:00 Pm",
                style: theme.textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Text(
                "La Rosalia",
                style: CustomTextStyles.titleMediumGray900_1,
              ),
            ),
            SizedBox(height: 6.h),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 10.h),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: appTheme.gray900,
                    size: 14.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      "Palau Sant Jordi, Barcelona",
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.favorite_border_outlined,
                    color: appTheme.gray900,
                    size: 18.h,
                  ),
                  Icon(
                    Icons.share_outlined,
                    color: appTheme.gray900,
                    size: 18.h,
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h)
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.h),
      child: ListView.separated(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return SizedBox(
            height: 18.h,
          );
        },
        itemCount: 3,
        itemBuilder: (context, index) {
          return GestureDetector(
      onTap: () {
        _navigateToEventPage(context, "The Kooks", "Thu, Apr 19 20.00 Pm", "Razzmatazz", "assets/images/Rectangle_4.png");
      },child: EventlistItemWidget( index: index),
          );
        },
      ),
    );
  }
  void _navigateToEventPage(BuildContext context, String eventName, String eventDate, String eventLocation, String eventImage) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EventPage(eventName: eventName, eventDate: eventDate, eventLocation: eventLocation, eventImage: eventImage),
    ),
  );
}

}
