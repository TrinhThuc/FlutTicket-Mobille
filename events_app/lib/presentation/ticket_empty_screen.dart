import 'package:events_app/app_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  TicketEmptyScreenState createState() => TicketEmptyScreenState();
}

class TicketEmptyScreenState extends State<TicketScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  void initState() {
    super.initState();
    tabviewController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      body: SafeArea(
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTicketsSection(context),
                Expanded(
                    child: Container(
                        child: TabBarView(
                  controller: tabviewController,
                  // children: [TicketTabPage(), TicketTabPage()]

                  children: const [TicketUpcomingiTabPage(), TicketpastTabPage()],
                ))),
              ]),
        ),
      ),
    );
  }

  Widget _buildTicketsSection(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.only(top: 44.h),
      decoration: AppDecoration.globalPrimary,
      child: Column(
        children: [
          CustomAppBar(
            title: AppbarTitle(
              text: 'Tickets',
              margin: EdgeInsets.symmetric(horizontal: 14.h, vertical: 22.h),
            ),
          ),
          // Spacer(),
          SizedBox(
            height: 16.h,
          ),
          Container(
            width: double.maxFinite,
            margin: EdgeInsets.symmetric(horizontal: 14.h),
            child: TabBar(
              controller: tabviewController,
              labelPadding: EdgeInsets.zero,
              labelColor: appTheme.whiteA700,
              labelStyle: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
              unselectedLabelColor: appTheme.gray100.withOpacity(0.75),
              unselectedLabelStyle: TextStyle(
                fontSize: 16.fSize,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
              indicatorColor: appTheme.whiteA700,
              tabs: const [
                Tab(
                  text: 'Upcoming',
                ),
                Tab(
                  text: 'Past Tickets',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
class TicketpastTabPage extends StatefulWidget {
  const TicketpastTabPage({super.key});

  @override
  TicketpastTabPageState createState() => TicketpastTabPageState();
}

class TicketpastTabPageState extends State<TicketpastTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
        child: Column(
          children: [
            SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '2022',
                              style: CustomTextStyles.titleMediumGray600_1,
                            ),
                            ListView.separated(
                              padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {

                                  return const ListtheWeekndItemWidget();
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 12.h,
                                  );
                                },
                                itemCount: 2)
                          ],
                        )),

                        SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '2021',
                                  style: CustomTextStyles.titleMediumGray600_1,
                                ),
                                ListView.separated(
                                  padding: EdgeInsets.zero,
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      
                                      return const ListnikMulveyItemWidget();
                                    },
                                    separatorBuilder: (context, index) {
                                      return SizedBox(
                                        height: 12.h,
                                      );
                                    },
                                    itemCount: 2)
                              ],
                            ))
                  ],
                )),
          ],
        ));
  }
}

class ListnikMulveyItemWidget extends StatelessWidget {
  const ListnikMulveyItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outlineGray.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder4),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        CustomImageView(
                          color: appTheme.greenA700,
                          imagePath: 'assets/images/empty_ticket.png',
                          width: 30.h,
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nick Mulvey",
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                "Mon, May 18 · 21:30 PM",
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      "2 tickets",
                      style: CustomTextStyles.bodySmallBlack900,
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: 'assets/images/placeholder.png',
            height: 96.h,
            width: 140.h,
            radius: BorderRadius.horizontal(right: Radius.circular(5.h)),
          )
        ],
      ),
    );
  }
}

class ListtheWeekndItemWidget extends StatelessWidget {
  const ListtheWeekndItemWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outlineGray.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder4),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.maxFinite,
                    child: Row(
                      children: [
                        CustomImageView(
                          color: appTheme.greenA700,
                          imagePath: 'assets/images/empty_ticket.png',
                          width: 30.h,
                          height: 30.h,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "The Weeknd",
                                style: theme.textTheme.titleMedium,
                              ),
                              Text(
                                "Mon, Feb 11 · 21:00 PM",
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    child: Text(
                      "1 tickets",
                      style: CustomTextStyles.bodySmallBlack900,
                    ),
                  )
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: 'assets/images/placeholder.png',
            height: 96.h,
            width: 140.h,
            radius: BorderRadius.horizontal(right: Radius.circular(5.h)),
          )
        ],
      ),
    );
  }
}

class TicketUpcomingiTabPage extends StatefulWidget {
  const TicketUpcomingiTabPage({super.key});

  @override
  TicketUpcomingiTabPageState createState() => TicketUpcomingiTabPageState();
}

class TicketUpcomingiTabPageState extends State<TicketUpcomingiTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 30.h),
        child: Column(
          children: [
            Expanded(
                child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: AppDecoration.outlineGray.copyWith(
                            borderRadius: BorderRadiusStyle.roundedBorder4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(horizontal: 8.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: double.maxFinite,
                                      child: Row(
                                        children: [
                                          CustomImageView(
                                            color: appTheme.greenA700,
                                            imagePath:
                                                'assets/images/empty_ticket.png',
                                            width: 30.h,
                                            height: 30.h,
                                            fit: BoxFit.cover,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "La Rosalia",
                                                  style: theme
                                                      .textTheme.titleMedium,
                                                ),
                                                Text(
                                                  "Mon, Apr 18 · 21:00 PM",
                                                  style:
                                                      theme.textTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4.h),
                                      child: Text(
                                        "2 tickets",
                                        style:
                                            CustomTextStyles.bodySmallBlack900,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            CustomImageView(
                              imagePath: 'assets/images/placeholder.png',
                              height: 96.h,
                              width: 140.h,
                              radius: BorderRadius.horizontal(
                                  right: Radius.circular(5.h)),
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 8.h,
                      );
                    },
                    itemCount: 3))
          ],
        ));
  }
}

class TicketTabPage extends StatefulWidget {
  const TicketTabPage({super.key});

  @override
  TicketTabPageState createState() => TicketTabPageState();
}

class TicketTabPageState extends State<TicketTabPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 134.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 4.h,
              ),
              SizedBox(
                width: double.maxFinite,
                child: Column(
                  children: [
                    SizedBox(
                      height: 86.h,
                      child: CustomImageView(
                        imagePath: 'assets/images/empty_ticket.png',
                        width: double.maxFinite,
                        fit: BoxFit.fitHeight,
                        height: 80.h,
                      ),
                    ),
                    SizedBox(
                      height: 44.h,
                    ),
                    Text(
                      'No Tickets yes',
                      style: theme.textTheme.titleMedium,
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    SizedBox(
                      width: double.maxFinite,
                      child: Text(
                        "Make sure you'r in the same account that purchased the tickets",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: CustomTextStyles.bodyLargeBlack900
                            .copyWith(height: 1.5),
                      ),
                    ),
                    SizedBox(
                      height: 42.h,
                    ),
                    CustomElevatedButton(
                      onPressed: () {},
                      text: 'try again',

                      buttonStyle: CustomButtonStyles.fillGreenA700,
                      // buttonTextStyle: CustomTextStyles.bodySmallWhiteA700,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
