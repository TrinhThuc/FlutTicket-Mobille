
import 'package:events_app/app_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> events = [
    {
      "date": "Thu, Apr 19 · 20.00 PM",
      "title": "Of Monster and Man",
      "location": "Razzmatazz",
      "imageUrl": "assets/images/placeholder.png",
      "isFavorite": true
    },
    {
      "date": "Fri, Apr 20 · 21.30 PM",
      "title": "Imagine Dragons",
      "location": "Olympic Stadium",
      "imageUrl": "assets/images/placeholder.png",
      "isFavorite": false
    },
    {
      "date": "Sat, Apr 21 · 19.00 PM",
      "title": "Coldplay",
      "location": "Wembley Arena",
      "imageUrl": "assets/images/placeholder.png",
      "isFavorite": true
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(top: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 22.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h),
              child: CustomSearchView(
                  controller: searchController,
                  hintText: 'Search For....',
                  contentPadding: EdgeInsets.only(
                    left: 12.h,
                    top: 6.h,
                    bottom: 6.h,
                  )),
            ),
            SizedBox(height: 12.h),

            // Filters Section
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.h),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 6.h,
                    runSpacing: 6.h,
                    children: List.generate(
                        8, (index) => const FilterChipviewItemWidget()),
                  ),
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 14.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.maxFinite,
                      margin: EdgeInsets.symmetric(horizontal: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('123 Events',
                              style: CustomTextStyles.bodyLargeBlack900),
                          Spacer(),
                          Text('Sort by relevant',
                              style: CustomTextStyles.bodySmallBlack900),
                          Icon(
                            Icons.arrow_drop_down,
                            size: 18.h,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(padding: EdgeInsets.only(left: 6.h),
                      child:ListView.separated(
                        padding: EdgeInsets.zero,
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 5,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 18.h);
                        },
                        itemBuilder: (context, index){
                          return EventListItenWidget();
                        }


                      )
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EventListItenWidget extends StatelessWidget {
  const EventListItenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomImageView(
          imagePath: 'assets/images/placeholder.png',
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
                  'Thu, Apr 19 · 20.00 PM',
                  style: theme.textTheme.bodySmall,
                ),
                SizedBox(height: 2.h),
                Text(
                  "Of Monster and Man",
                  style: CustomTextStyles.titleMediumGray900_1,
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4.h),
                        child: Text(
                          'Razzmatazz',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        Icon(Icons.favorite, color: Colors.red),
        SizedBox(width: 10.h),
        Icon(Icons.share, color: Colors.grey),
      ],
    );

  }
}

/// **🔹 Filter Chip Widget**
class FilterChipviewItemWidget extends StatelessWidget {
  const FilterChipviewItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: EdgeInsets.only(left: 12.h, top: 4.h, bottom: 4.h),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        'Filters',
        style: TextStyle(
          color: appTheme.black900,
          fontSize: 12.fSize,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
        ),
      ),
      deleteIcon: const Icon(Icons.arrow_drop_down_outlined),
      onDeleted: () {},
      selected: false,
      backgroundColor: appTheme.gray100.withOpacity(0.46),
      selectedColor: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
          side: BorderSide.none, borderRadius: BorderRadius.circular(5.h)),
      onSelected: (bool value) {},
    );
  }
}

/// **🔹 Event List Item Widget**
class EventItem extends StatelessWidget {
  final String date;
  final String title;
  final String location;
  final String imageUrl;
  final bool isFavorite;

  const EventItem({
    super.key,
    required this.date,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.h),
            child: Image.asset(imageUrl,
                width: 88.h, height: 84.h, fit: BoxFit.cover),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: theme.textTheme.bodySmall),
                Text(title, style: CustomTextStyles.titleMediumGray900_1),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.grey),
                    SizedBox(width: 4.h),
                    Text(location, style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          SizedBox(width: 12.h),
          const Icon(Icons.share, color: Colors.grey),
        ],
      ),
    );
  }
}
