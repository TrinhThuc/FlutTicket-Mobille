import 'package:events_app/app_theme.dart';
import 'package:events_app/app_utils.dart';
import 'package:flutter/material.dart';

import '../service/api_service.dart';
import '../widgets.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  List favEvents = [];

  @override
  void initState() {
    super.initState();
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
      print('Lỗi: Không nhận được dữ liệu favourite events');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child:
            favEvents.isEmpty ? _buildEmptyFavourites() : _buildFavoriteItem(),
      ),
    );
  }

  Widget _buildEmptyFavourites() {
    return Container(
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
          Text('Chưa có mục yêu thích nào', style: theme.textTheme.titleMedium),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.maxFinite,
            child: Text(
              "Hãy đảm bảo bạn đã đăng nhập để lưu các sự kiện yêu thích của mình",
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyles.bodyLargeBlack900.copyWith(height: 1.5),
            ),
          ),
          SizedBox(height: 42.h),
          CustomElevatedButton(
            onPressed: () {},
            text: 'Thêm vào yêu thích',
            buttonStyle: CustomButtonStyles.fillGreenA700,
          ),
        ],
      ),
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
                        Text("Yêu thích", style: theme.textTheme.titleLarge),
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
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 18.h),
                        itemBuilder: (context, index) {
                          return FavouritesItemWidget(event: favEvents[index]);
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

  const FavouritesItemWidget({super.key, required this.event});

  @override
  State<FavouritesItemWidget> createState() => _FavouritesItemWidgetState();
}

class _FavouritesItemWidgetState extends State<FavouritesItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 88.h,
          height: 84.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.h),
            image: DecorationImage(
              image: NetworkImage(widget.event['eventPoster'] ??
                  'https://example.com/default_image.png'),
              fit: BoxFit.cover,
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
                  widget.event['startTime'] ?? 'Ngày không xác định',
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.event['name'] ?? 'Tên sự kiện không xác định',
                  style: CustomTextStyles.titleMediumGray900_1,
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Flexible(
                    child: Row(
                      children: [
                        Icon(Icons.location_on, size: 16.h),
                        SizedBox(width: 4.h),
                        Expanded(
                          child: Text(
                            widget.event['location'] ??
                                'Địa điểm không xác định',
                            style: theme.textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            (widget.event['isFav'] ?? false)
                ? Icons.favorite
                : Icons.favorite_border_outlined,
            color: (widget.event['isFav'] ?? false)
                ? Colors.red
                : appTheme.gray900,
            size: 18.h,
          ),
          onPressed: () {
            // Thêm sự kiện vào danh sách yêu thích
            setState(() {
              bool isFav = widget.event['isFav'] ?? false;
              ApiService.requestApi(
                isFav
                    ? 'event/private/remove-favourite-event/${widget.event['id']}'
                    : 'event/private/add-favourite-event/${widget.event['id']}',
               
                {},
                useAuth: true,
              ).then((response) {
                if (response != null) {
                  setState(() {
                    widget.event['isFav'] = !isFav;
                  });
                }
              });
            });
          },
        ),
      ],
    );
  }
}
