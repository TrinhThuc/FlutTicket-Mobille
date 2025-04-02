import 'package:events_app/app_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'buy_ticket_screen.dart';

class EventPage extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventLocation;
  final String eventImage;

  const EventPage({
    super.key,
    required this.eventName,
    required this.eventDate,
    required this.eventLocation,
    required this.eventImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.only(
                left: 24.h,
              ),
              child: Text(
                eventName,
                style: CustomTextStyles.headlineSmallBlack900,
              ),
            ),
            SizedBox(height: 28.h),
            _buildEventDetails(context),
            SizedBox(height: 28.h),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 26.h),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 18.h),
                  SizedBox(width: 8.h),
                  Padding(
                    padding: EdgeInsets.only(left: 10.h),
                    child: Text(eventLocation,
                        style: CustomTextStyles.titleMediumGray900_1
                            .copyWith(color: appTheme.gray900)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.only(left: 26.h),
              child: Text(
                'Passeig Olímpic, 5-7, 08038 Barcelona',
                style: theme.textTheme.bodySmall,
              ),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 26.h),
              child: Text(
                'View on maps',
                style: theme.textTheme.labelLarge,
              ),
            ),
            SizedBox(height: 28.h),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 26.h),
              child: Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 18.h,
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 10.h),
                    child: Text('Refund Policy',
                        style: CustomTextStyles.titleMediumGray900_1
                            .copyWith(color: appTheme.gray900)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.only(left: 26.h),
              child: Text(
                'Flut fee is not-refundable.',
                style: theme.textTheme.bodySmall,
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.only(left: 24.h),
              child: Text('About',
                  style: CustomTextStyles.titleMediumGray900_1
                      .copyWith(color: appTheme.gray900)),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 24.h),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                style: theme.textTheme.bodySmall!.copyWith(height: 1.6),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 52.h),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return SizedBox(
      height: 194.h,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomImageView(
              imagePath: eventImage, height: 194.h, width: double.maxFinite),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.maxFinite,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: 14.h),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24.h,
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 6.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.favorite_border,
                                            size: 18.h, color: Colors.white),
                                        onPressed: () {},
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.share,
                                            size: 18.h, color: Colors.white),
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.symmetric(horizontal: 26.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.maxFinite,
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 18.h),
                Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: Text(eventDate,
                      style: CustomTextStyles.titleMediumGray900_1
                          .copyWith(color: appTheme.gray900)),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '21:00 PM - 23.30 PM',
            style: theme.textTheme.bodySmall,
          ),
          SizedBox(height: 8.h),
          Text(
            'Add to calendar',
            style: theme.textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 90.h,
      padding:  EdgeInsets.symmetric(horizontal: 14.h, vertical: 20.h),
      decoration: AppDecoration.globalGrey,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // spacing: 4.h,
            mainAxisSize: MainAxisSize.min,           
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Price',
                  style: CustomTextStyles.titleMediumGray900_1
                      ),
              Text('€ 35.00 - € 75.00', style: theme.textTheme.bodyLarge),
            ],
          ),
          //  CustomElevatedButton(

          //   height: 44.h,
          // width: 188.h,
          //   text: "Tickets",
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(14.h)),
          //   ),
          //   buttonStyle: CustomButtonStyles.fillGreenA700,
          //   buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
          //   alignment: Alignment.topLeft,
          // ),

          CustomElevatedButton(
  height: 44.h,
  width: 188.h,
  text: "Tickets",
  buttonStyle: ElevatedButton.styleFrom(
    backgroundColor: appTheme.greenA700, // ✅ Set button color
    shape: RoundedRectangleBorder( // ✅ Apply rounded corners here
      borderRadius: BorderRadius.circular(10.h),
    ),
  ),
  buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
  alignment: Alignment.center,
  onPressed: () {
    // ✅ Navigate to the BuyTicketScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuyTicketScreen(
          eventName: eventName,
          eventDate: eventDate,
          eventLocation: eventLocation,
        ),
      ),
    );

  },

),

          
        ],
      ),
    );
  }
}
