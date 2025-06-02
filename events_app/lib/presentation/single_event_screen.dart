import 'dart:developer';

import 'package:events_app/app_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart';
import 'buy_ticket_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  final int eventId;

  const EventPage({
    super.key,
    required this.eventId,
  });

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  Map<String, dynamic> eventDetails = {};

  @override
  void initState() {
    super.initState();
    getEventDetails(widget.eventId);
  }

  Future<void> getEventDetails(int eventId) async {
    final response =
        await ApiService.requestGetApi('event/public/$eventId', useAuth: false);
    if (response != null) {
      log('getEventDetails response data: ${response['data']}');

      setState(() {
        eventDetails = response['data'] ?? {};
      });
    } else {
      print(AppVietnameseStrings.eventDataEmptyOrInvalid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(context),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.only(left: 24.h),
              child: Text(
                eventDetails['name'] ??
                    AppVietnameseStrings.eventNameUnavailable,
                style: CustomTextStyles.headlineSmallBlack900,
              ),
            ),
            SizedBox(height: 28.h),
            _buildEventDetails(context),
            SizedBox(height: 28.h),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 26.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_outlined, size: 18.h),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Text(
                          eventDetails['location'] ??
                              AppVietnameseStrings.locationUnavailable,
                          style: CustomTextStyles.titleMediumGray900_1.copyWith(
                            color: appTheme.gray900,
                          ),
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () async {
                      final location = eventDetails['location'];
                      if (location != null && location.isNotEmpty) {
                        final encodedLocation = Uri.encodeComponent(location);
                        final googleMapsUrl =
                            'https://www.google.com/maps/search/?api=1&query=$encodedLocation';
                        final uri = Uri.parse(googleMapsUrl);

                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          // Optional: thông báo lỗi
                          print("Không thể mở bản đồ.");
                        }
                      }
                    },
                    child: Text(
                      AppVietnameseStrings.viewOnMap,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 26.h),
              child: Row(
                children: [
                  Icon(Icons.attach_money, size: 18.h),
                  const SizedBox(width: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 10.h),
                    child: Text(AppVietnameseStrings.refundPolicyTitle,
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
                AppVietnameseStrings.flutFeeNonRefundable,
                style: theme.textTheme.bodySmall,
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.only(left: 24.h),
              child: Text(AppVietnameseStrings.aboutSectionTitle,
                  style: CustomTextStyles.titleMediumGray900_1
                      .copyWith(color: appTheme.gray900)),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 24.h),
              child: Text(
                eventDetails['description'] ??
                    AppVietnameseStrings.descriptionUnavailable,
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
          Container(
            width: double.maxFinite,
            height: 194.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  'http://162.248.102.236:8055/assets/${eventDetails['eventPoster'] ?? ''}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
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

  // Hàm xin quyền calendar
  Future<bool> requestCalendarPermission() async {
    var status = await Permission.calendar.status;
    if (!status.isGranted) {
      status = await Permission.calendar.request();
    }
    return status.isGranted;
  }

  Widget _buildEventDetails(BuildContext context) {
    // Tạo Event để thêm vào lịch
    final event = Event(
      title: eventDetails['name'] ?? 'Sự kiện',
      description: eventDetails['description'] ?? '',
      location: eventDetails['location'] ?? '',
      startDate: eventDetails['startTime'] != null
          ? DateTime.parse(eventDetails['startTime'])
          : DateTime.now(),
      endDate: eventDetails['endTime'] != null
          ? DateTime.parse(eventDetails['endTime'])
          : DateTime.now().add(const Duration(hours: 1)),
    );

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
                  child: Text(
                      eventDetails['startTime'] != null
                          ? DateFormat('dd/MM/yyyy HH:mm')
                              .format(DateTime.parse(eventDetails['startTime']))
                          : '',
                      style: CustomTextStyles.titleMediumGray900_1
                          .copyWith(color: appTheme.gray900)),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          GestureDetector(
            onTap: () async {
              final granted = await requestCalendarPermission();
              if (granted) {
                Add2Calendar.addEvent2Cal(event);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Cần cấp quyền truy cập lịch để thêm sự kiện')),
                );
              }
            },
            child: Text(
              AppVietnameseStrings.addToCalendar,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 120.h,
      padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 20.h),
      decoration: AppDecoration.globalGrey,
      width: double.maxFinite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Giá vé', style: CustomTextStyles.titleMediumGray900_1),
              Text(
                  formatCurrencyVND((eventDetails['listTicket'] != null &&
                          eventDetails['listTicket'].isNotEmpty
                      ? (eventDetails['listTicket'][0]['price'] as num?)
                              ?.toInt() ??
                          0
                      : 0)),
                  style: theme.textTheme.bodyLarge),
            ],
          ),
          CustomElevatedButton(
            height: 44.h,
            width: 188.h,
            text: AppVietnameseStrings.getTicketsButton,
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: appTheme.greenA700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.h),
              ),
            ),
            buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
            alignment: Alignment.center,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuyTicketScreen(
                    eventDetails: eventDetails, // Bỏ key để khắc phục lỗi
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
