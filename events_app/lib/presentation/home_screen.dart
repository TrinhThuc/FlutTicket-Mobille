import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_theme.dart';
import '../app_utils.dart';
import '../service/api_service.dart';
import '../widgets.dart';
import 'single_event_screen.dart';

class HomeScreen extends StatelessWidget {
  final String selectedLocation;

  const HomeScreen({super.key, required this.selectedLocation});

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

class EventlistItemWidget extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventlistItemWidget({super.key, required this.event});

  @override
  State<EventlistItemWidget> createState() => _EventlistItemWidgetState();
}

class _EventlistItemWidgetState extends State<EventlistItemWidget> {
  bool isProcessing = false;

  void _toggleFavourite() async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
    });

    final isFav = widget.event['isFav'] ?? false;
    final eventId = widget.event['id'];

    String endpoint = isFav
        ? 'event/private/remove-favourite-event/$eventId'
        : 'event/private/add-favourite-event/$eventId';
    final response = await ApiService.requestApi(endpoint, {}, 
        useAuth: true);
    if (response != null) {
      setState(() {
        widget.event['isFav'] = !isFav;
      });
    }

    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final isFav = event['isFav'] ?? false;

    return SizedBox(
      height: 96.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            children: [
              Image.network(
                'http://162.248.102.236:8055/assets/${event['eventPoster'] ?? ''}',
                height: 84.h,
                width: 88.h,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => CustomImageView(
                  imagePath: 'assets/images/No-Image.png',
                  width: 88.h,
                  height: 84.h,
                  fit: BoxFit.cover,
                  radius: BorderRadius.circular(10.h),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${event['startTime'] ?? ''}",
                        style: theme.textTheme.bodySmall,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        event['name'] ?? '',
                        style: CustomTextStyles.titleMediumGray900_1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: appTheme.gray900,
                            size: 14.h,
                          ),
                          SizedBox(width: 4.h),
                          Expanded(
                            child: Text(
                              event['location'] ?? '',
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border_outlined,
                  color: isFav ? Colors.red : appTheme.gray900,
                  size: 18.h,
                ),
                onPressed: _toggleFavourite,
              ),
              Icon(
                Icons.share_outlined,
                color: appTheme.gray900,
                size: 18.h,
              ),
            ],
          ),
          if (event['isNew'] == true)
            Positioned(
              top: 0,
              left: 46.h,
              child: CustomElevatedButton(
                height: 26.h,
                width: 36.h,
                text: "New",
                buttonStyle: CustomButtonStyles.fillGreenA,
                buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
              ),
            ),
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
  List popularEvents = [];
  String selectedLocation = 'Hà Nội';

  @override
  void initState() {
    super.initState();
    _loadSelectedLocation();
    _getPopularEvents();
  }

  Future<void> _loadSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLocation = prefs.getString('selectedLocation') ?? 'Hà Nội';
    });
  }

  Future<void> _getPopularEvents() async {
    final response = await ApiService.requestGetApi(
      'event/public/get-popular-event',
    );
    if (response != null) {
      setState(() {
        popularEvents = response['data']['content'] ?? [];
      });
    } else {
      debugPrint('Lỗi: Không nhận được dữ liệu hợp lệ');
    }
  }

  void _navigateToEventPage(BuildContext context, int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventPage(eventId: id),
      ),
    );
  }

  Widget _buildEventTile() {
    if (popularEvents.isEmpty) return const SizedBox();
    final event = popularEvents[0];
    DateTime? startTime;

    try {
      startTime = DateTime.parse(event['startTime'] ?? '');
    } catch (_) {}

    return GestureDetector(
      onTap: () => _navigateToEventPage(context, event['id']),
      child: Container(
        width: double.maxFinite,
        decoration: AppDecoration.globalGrey.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 120.h,
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    'http://162.248.102.236:8055/assets/${event['eventPoster'] ?? ''}',
                    height: 120.h,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => CustomImageView(
                      imagePath: 'assets/images/No-Image.png',
                      width: double.maxFinite,
                      height: 120.h,
                      fit: BoxFit.cover,
                      radius: BorderRadius.circular(52.h),
                    ),
                  ),
                  if (event['isNew'] == true)
                    Positioned(
                      top: 8.h,
                      right: 8.h,
                      child: CustomElevatedButton(
                        height: 26.h,
                        width: 38.h,
                        text: "New",
                        buttonStyle: CustomButtonStyles.fillGreenA,
                        buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Text(
                startTime != null
                    ? DateFormat('dd/MM/yyyy HH:mm').format(startTime)
                    : '',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Text(
                event['name'] ?? '',
                style: CustomTextStyles.titleMediumGray900_1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 6.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: appTheme.gray900,
                    size: 14.h,
                  ),
                  SizedBox(width: 4.h),
                  Expanded(
                    child: Text(
                      event['location'] ?? '',
                      style: theme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      (event['isFav'] ?? false)
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: (event['isFav'] ?? false)
                          ? Colors.red
                          : appTheme.gray900,
                      size: 18.h,
                    ),
                    onPressed: () async {
                      final isFav = event['isFav'] ?? false;
                      final endpoint = isFav
                          ? 'event/private/remove-favourite-event/${event['id']}'
                          : 'event/private/add-favourite-event/${event['id']}';
                      
                      final response =
                          await ApiService.requestApi(endpoint, {}, 
                              useAuth: true);
                      if (response != null) {
                        setState(() {
                          event['isFav'] = !isFav;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.share_outlined,
                        color: appTheme.gray900, size: 18.h),
                    onPressed: () {
                      // TODO: Implement sharing logic
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList() {
    if (popularEvents.isEmpty) return const SizedBox();

    return Padding(
      padding: EdgeInsets.only(right: 8.h),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: popularEvents.length,
        separatorBuilder: (_, __) => SizedBox(height: 18.h),
        itemBuilder: (context, index) {
          final event = popularEvents[index];
          return GestureDetector(
            onTap: () => _navigateToEventPage(context, event['id']),
            child: EventlistItemWidget(event: event),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: AppDecoration.fillwhiteA,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Popular in $selectedLocation",
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: 14.h),
                    _buildEventTile(),
                    SizedBox(height: 14.h),
                    _buildEventList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
