import 'package:events_app/app_theme.dart';
import 'package:events_app/app_utils.dart';
import 'package:flutter/material.dart';

import '../app_routes.dart';
import '../widgets.dart';

class FavouritesScreen extends StatelessWidget {
  FavouritesScreen({super.key});

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: _buildFavoriteItem(),
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
              SizedBox(
                height: 24.h,
              ),
              SizedBox(
                height: 86.h,
                child: CustomImageView(
                  imagePath: 'assets/images/empty_favourites.png',
                  width: double.maxFinite,
                  fit: BoxFit.fitHeight,
                  height: 80.h,
                ),
              ),
              SizedBox(
                height: 44.h,
              ),
              Text(
                'No favourites yet',
                style: theme.textTheme.titleMedium,
              ),
              SizedBox(
                height: 8.h,
              ),
              SizedBox(
                width: double.maxFinite,
                child: Text(
                  "Make sure you're signed in to save your favourite events",
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style:
                      CustomTextStyles.bodyLargeBlack900.copyWith(height: 1.5),
                ),
              ),
              SizedBox(
                height: 42.h,
              ),
              CustomElevatedButton(
                onPressed: () {},
                text: 'Add Favourites',

                buttonStyle: CustomButtonStyles.fillGreenA700,
                // buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
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
                              Text(
                                "Favourites",
                                style: theme.textTheme.titleLarge,
                              ),
                              Container(
                                width: 26.h,
                                height: 26.h,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 8.h),
                                decoration: AppDecoration.globalPrimary
                                    .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder14),
                                child: Text(
                                  "2",
                                  textAlign: TextAlign.center,
                                  style: CustomTextStyles.titleMediumWhiteA700,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 6.h),
                                child: ListView.separated(
                                    itemCount: 2,
                                    padding: EdgeInsets.zero,
                                    physics: BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 18.h),
                                    itemBuilder: (context, index) {
                                      return FavouritesItemWidget();
                                    }))),
                      ],
                    )))
          ],
        ));
  }

}

class FavouritesItemWidget extends StatelessWidget {
  FavouritesItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomImageView(
          imagePath: 'assets/images/Rectangle_4.png',
          width: 88.h,
          height: 84.h,
          radius: BorderRadius.circular(10.h),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thu, Apr 14 · 19:00 PM',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(
                height: 4.h,
              ),
              Text(
                'Of Monsters and Man',
                style: CustomTextStyles.titleMediumGray900_1,
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 4.h),
                      child: Text(
                        'Razzmatazz',
                        style: theme.textTheme.bodySmall,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
        Icon(
          Icons.favorite,
          color: appTheme.redA700,
          size: 24.h,
        ),
        Icon(
          Icons.share,
          color: appTheme.gray900,
          size: 24.h,
        ),
      ],
    );
  }
}
