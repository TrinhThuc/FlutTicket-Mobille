import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../app_utils.dart';
import '../service/api_service.dart';
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
      body: const SafeArea(
        child: HomeInitialPage(),
      ),
    );
  }
}

/// **Home Initial Page with Events**
class EventlistItemWidget extends StatefulWidget {
  const EventlistItemWidget({super.key, required this.index});
  final int index;

  @override
  State<EventlistItemWidget> createState() => _EventlistItemWidgetState();
}

class _EventlistItemWidgetState extends State<EventlistItemWidget> {
  @override
  Widget build(BuildContext context) {
    final event = (context
            .findAncestorStateOfType<_HomeInitialPageState>()
            ?.popularEvents ??
        [])[widget.index];
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
                      imagePath: "assets/images/${event['eventPoster']}",
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
                              "${event['startTime']}",
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              event['name'],
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
                                      event['location'],
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
                     IconButton(
                    icon: Icon(
                      event['isFav'] ? Icons.favorite : Icons.favorite_border_outlined,
                      color: event['isFav'] ? Colors.red : appTheme.gray900,
                      size: 18.h,
                    ),
                    onPressed: () {
                      // Thêm sự kiện vào danh sách yêu thích
                      setState(() {
                        ApiService.requestApi(
                          event['isFav']
                              ? 'event/private/remove-favourite-event/${event['id']}'
                              : 'event/private/add-favourite-event/${event['id']}',
                          event['isFav'] ? 'remove-fav-event' : 'add-fav-event',
                          {},
                        ).then((response) {
                          if (response != null) {
                            event['isFav'] = !event['isFav'];
                          }
                        });
                      });
                    },
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
          widget.index == 0
              ? CustomElevatedButton(
                  height: 26.h,
                  width: 36.h,
                  text: "New",
                  margin: EdgeInsets.only(left: 46.h),
                  buttonStyle: CustomButtonStyles.fillGreenA,
                  buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
                  alignment: Alignment.topLeft,
                )
              : const SizedBox(),
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

  List popularEvents = [];

  @override
  void initState() {
    super.initState();
    _getPopularEvents();
  }

  Future<void> _getPopularEvents() async {
    final response = await ApiService.requestGetApi(
        'event/public/get-popular-event', 'get-popular-event');

    if (response != null) {
      setState(() {
        popularEvents = response['data']['content'];
      });
    } else {
      print('Lỗi: Không nhận được dữ liệu user hợp lệ');
    }
  }

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
                Icon(
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
        final event = popularEvents[0];
        _navigateToEventPage(context, event['id']);
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
                    imagePath: popularEvents.isNotEmpty
                        ? "assets/images/${popularEvents[0]['eventPoster']}"
                        : "assets/images/default_poster.jpg",
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
                popularEvents.isNotEmpty &&
                        popularEvents[0]['startTime'] != null
                    ? DateFormat('dd/MM/yyyy HH:mm')
                        .format(DateTime.parse(popularEvents[0]['startTime']))
                    : '',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Text(
                popularEvents[0]['name'],
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
                      popularEvents[0]['location'],
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
                  IconButton(
                    icon: Icon(
                      popularEvents[0]['isFav'] ? Icons.favorite : Icons.favorite_border_outlined,
                      color: popularEvents[0]['isFav'] ? Colors.red : appTheme.gray900,
                      size: 18.h,
                    ),
                    onPressed: () {
                      // Thêm sự kiện vào danh sách yêu thích
                      setState(() {
                        ApiService.requestApi(
                          popularEvents[0]['isFav']
                              ? 'event/private/remove-favourite-event/${popularEvents[0]['id']}'
                              : 'event/private/add-favourite-event/${popularEvents[0]['id']}',
                          popularEvents[0]['isFav'] ? 'remove-fav-event' : 'add-fav-event',
                          {},
                        ).then((response) {
                          if (response != null) {
                            popularEvents[0]['isFav'] = !popularEvents[0]['isFav'];
                          }
                        });
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: appTheme.gray900,
                      size: 18.h,
                    ),
                    onPressed: () {
                      // Thêm hành động khi nhấn vào icon
                    },
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
        itemCount: popularEvents.length,
        itemBuilder: (context, index) {
          final event = popularEvents[index];
          return GestureDetector(
            onTap: () {
              _navigateToEventPage(context, event['id']);
            },
            child: EventlistItemWidget(index: index),
          );
        },
      ),
    );
  }

  void _navigateToEventPage(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPage(eventId: id),
      ),
    );
  }
}
