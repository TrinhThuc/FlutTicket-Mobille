import 'package:events_app/app_theme.dart';
import 'package:events_app/app_utils.dart';
import 'package:events_app/utils/auth_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart';
import '../widgets.dart';
import 'single_event_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => FavouritesScreenState();
}

class FavouritesScreenState extends State<FavouritesScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List favEvents = [];

  @override
  void initState() {
    super.initState();
    AuthUtils.checkLogin(context);
    _getFavEvents();
  }

  Future<void> _getFavEvents() async {
    final response = await ApiService.requestGetApi(
        'event/private/get-favourite-event',
        useAuth: true);

    if (response != null) {
      setState(() {
        favEvents = response['data'];
      });
    } else {
      print(AppVietnameseStrings.errorNoFavoriteEvents);
    }
  }

  Future<void> _onRefresh() async {
    await _getFavEvents();
  }

  void refreshData() {
    setState(() {
      // Gọi lại các hàm load dữ liệu
      _getFavEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: favEvents.isEmpty
              ? _buildEmptyFavourites()
              : _buildFavoriteItem(),
        ),
      ),
    );
  }

  Widget _buildEmptyFavourites() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(), // bắt buộc scroll được
      children: [
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.all(24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              SizedBox(
                height: 86.h,
                child: CustomImageView(
                  imagePath: 'assets/images/empty_favourites.png',
                  width: double.maxFinite,
                  fit: BoxFit.fitHeight,
                  height: 80.h,
                ),
              ),
              SizedBox(height: 44.h),
              Text(AppVietnameseStrings.noFavoritesYetTitle,
                  style: theme.textTheme.titleMedium),
              SizedBox(height: 8.h),
              SizedBox(
                width: double.maxFinite,
                child: Text(
                  AppVietnameseStrings.loginToSaveFavoritesMessage,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style:
                      CustomTextStyles.bodyLargeBlack900.copyWith(height: 1.5),
                ),
              ),
              SizedBox(height: 42.h),
              CustomElevatedButton(
                onPressed: () {},
                text: AppVietnameseStrings.addToFavoritesButton,
                buttonStyle: CustomButtonStyles.fillGreenA700,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteItem() {
    return Container(
      padding: EdgeInsets.only(left: 12.h, right: 12.h, top: 22.h),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.symmetric(horizontal: 6.h),
                    child: Row(
                      children: [
                        Text(AppVietnameseStrings.favoritesTitle,
                            style: theme.textTheme.titleLarge),
                        Container(
                          width: 26.h,
                          height: 26.h,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 8.h),
                          decoration: AppDecoration.globalPrimary.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder14),
                          child: Text(
                            "${favEvents.length}",
                            textAlign: TextAlign.center,
                            style: CustomTextStyles.titleMediumWhiteA700,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 6.h),
                      child: ListView.separated(
                        itemCount: favEvents.length,
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 18.h),
                        itemBuilder: (context, index) {
                          return FavouritesItemWidget(
                            event: favEvents[index],
                            onChanged: _getFavEvents, // truyền callback xuống
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavouritesItemWidget extends StatefulWidget {
  final dynamic event;
  final VoidCallback onChanged;

  const FavouritesItemWidget(
      {super.key, required this.event, required this.onChanged});

  @override
  State<FavouritesItemWidget> createState() => _FavouritesItemWidgetState();
}

class _FavouritesItemWidgetState extends State<FavouritesItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(eventId: widget.event['id']),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            width: 88.h,
            height: 84.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.h),
              child: CachedNetworkImage(
                imageUrl:
                    "http://162.248.102.236:8055/assets/${widget.event['eventPoster'] ?? ''}",
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/default_image.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(
                        widget.event['startTime'] ??
                            DateTime.now().toIso8601String())),
                    // widget.event['startTime'] ?? 'Ngày không xác định',
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    widget.event['name'] ??
                        AppVietnameseStrings.eventNameUnavailable,
                    style: CustomTextStyles.titleMediumGray900_1,
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 16.h),
                        SizedBox(width: 4.h),
                        Expanded(
                          child: Text(
                            widget.event['location'] ??
                                AppVietnameseStrings.locationUnavailable,
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
              size: 18.h,
            ),
            onPressed: () {
              ApiService.requestApi(
                'event/private/remove-favourite-event/${widget.event['id']}',
                {},
                useAuth: true,
              ).then((response) {
                if (response != null) {
                  widget.onChanged(); // gọi callback để refresh danh sách fav
                } else {
                  print('Lỗi: Không thể xóa sự kiện khỏi danh sách yêu thích');
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
