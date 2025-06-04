import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

//
import '../app_theme.dart';
import '../app_utils.dart';
import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart';
import '../widgets.dart';
import 'single_event_screen.dart';

class HomeScreen extends StatefulWidget {
  final String selectedLocation;

  const HomeScreen({super.key, required this.selectedLocation});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: HomeInitialPage(selectedLocation: widget.selectedLocation),
          ),
        );
      },
    );
  }

  void refreshData() {
    setState(() {
      // Refresh toàn bộ màn hình
    });
  }
}

class EventlistItemWidget extends StatefulWidget {
  final Map<String, dynamic> event;
  final List favEvents;
  final VoidCallback onFavouriteChanged;

  const EventlistItemWidget({
    super.key,
    required this.event,
    required this.favEvents,
    required this.onFavouriteChanged,
  });

  @override
  State<EventlistItemWidget> createState() => _EventlistItemWidgetState();
}

class _EventlistItemWidgetState extends State<EventlistItemWidget> {
  bool isProcessing = false;

  bool get isFav => widget.favEvents.contains(widget.event['id']);

  void _toggleFavourite() async {
    if (isProcessing) return;
    setState(() {
      isProcessing = true;
    });

    // Nếu chưa đăng nhập thì không cho thao tác yêu thích
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      ApiService.showLoginRequiredDialog(context);
      setState(() {
        isProcessing = false;
      });
      return;
    }

    final eventId = widget.event['id'];

    String endpoint = isFav
        ? 'event/private/remove-favourite-event/$eventId'
        : 'event/private/add-favourite-event/$eventId';
    final response = await ApiService.requestApi(endpoint, {}, useAuth: true);
    if (response != null) {
      widget.onFavouriteChanged(); // Gọi callback cập nhật
    }

    setState(() {
      isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return SizedBox(
      height: 96.h,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            children: [
              // Hiển thị hình ảnh
              CachedNetworkImage(
                imageUrl:
                    'http://162.248.102.236:8055/assets/${event['eventPoster'] ?? ''}',
                height: 84.h,
                width: 88.h,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => CustomImageView(
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
                        DateFormat('dd MMM yyyy • hh:mm a').format(
                            DateTime.parse(event['startTime'] ??
                                DateTime.now().toIso8601String())),
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
                text: AppVietnameseStrings.newLabel,
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
  final String selectedLocation;
  
  const HomeInitialPage({super.key, required this.selectedLocation});

  @override
  HomeInitialPageState createState() => HomeInitialPageState();
}

class HomeInitialPageState extends State<HomeInitialPage> {
  List popularEvents = [];
  List favEvents = [];
  bool isLoggedIn = false;
  late String selectedLocation;

  Future<void> _onRefresh() async {
    await _loadSelectedLocation();
    await _getPopularEvents();
    await _getFavEvents();
    setState(() {}); // để cập nhật lại màn hình
  }

  void refreshData() {
    setState(() async {
      await _loadSelectedLocation();
      await _getPopularEvents();
      await _getFavEvents();
    });
  }

  Future<void> _loadSelectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLocation = prefs.getString('selectedLocation') ?? widget.selectedLocation;
    });
  }

  @override
  void initState() {
    super.initState();
    selectedLocation = widget.selectedLocation;
    _loadSelectedLocation();
    _getPopularEvents();
    _getFavEvents();
  }

  Future<void> _getFavEvents() async {
    // Kiểm tra đăng nhập
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    if (accessToken == null) {
      setState(() {
        favEvents = [];
        isLoggedIn = false;
      });
      return;
    }
    setState(() {
      isLoggedIn = true;
    });

    final response = await ApiService.requestGetApi(
        'event/private/get-favourite-event',
        context: context,
        useAuth: true);

    if (response != null) {
      setState(() {
        favEvents = List<int>.from(response['data'].map((e) => e['id']));
      });
    } else {
      print(AppVietnameseStrings.errorNoFavoriteEvents);
    }
  }

  Future<void> _getPopularEvents() async {
    final response = await ApiService.requestGetApi(
      'event/public/get-popular-event',
      context: context,
      useAuth: false,
    );
    if (response != null) {
      setState(() {
        popularEvents = response['data']['content'] ?? [];
      });
    } else {
      debugPrint(AppVietnameseStrings.eventDataEmptyOrInvalid);
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
                  CachedNetworkImage(
                    imageUrl:
                        'http://162.248.102.236:8055/assets/${event['eventPoster'] ?? ''}',
                    height: 120.h,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => CustomImageView(
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
                        text: AppVietnameseStrings.newLabel,
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
                    ? DateFormat('EEEE, dd MMM yyyy • hh:mm a')
                        .format(startTime)
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
                      favEvents.contains(event['id'])
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: favEvents.contains(event['id'])
                          ? Colors.red
                          : appTheme.gray900,
                      size: 18.h,
                    ),
                    onPressed: isLoggedIn
                        ? () async {
                            final isFav = favEvents.contains(event['id']);
                            final endpoint = isFav
                                ? 'event/private/remove-favourite-event/${event['id']}'
                                : 'event/private/add-favourite-event/${event['id']}';

                            final response = await ApiService.requestApi(endpoint, {},
                                useAuth: true);
                            if (response != null) {
                              await _getFavEvents();

                              setState(() {});
                            }
                          }
                        : () {
                            ApiService.showLoginRequiredDialog(context);
                          },
                  ),
                  IconButton(
                    icon: Icon(Icons.share_outlined,
                        color: appTheme.gray900, size: 18.h),
                    onPressed: () {
                      Share.share(
                        'Check out this event: ${event['name'] ?? ''} at ${event['location'] ?? ''}',
                      );
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
            child: EventlistItemWidget(
              event: event,
              favEvents: favEvents,
              onFavouriteChanged: () {
                setState(() {
                  favEvents = favEvents.contains(event['id'])
                      ? favEvents.where((id) => id != event['id']).toList()
                      : [...favEvents, event['id']];
                });
              },
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Container(
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
                        "${AppVietnameseStrings.popularInPrefix}$selectedLocation",
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
      ),
    );
  }
}
