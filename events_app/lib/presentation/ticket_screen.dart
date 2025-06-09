import 'package:events_app/app_utils.dart';
import 'package:events_app/presentation/ticket_detail.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện để định dạng ngày

import '../app_theme.dart';
import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart'; // Import
import '../utils/auth_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({super.key});

  @override
  TicketEmptyScreenState createState() => TicketEmptyScreenState();
}

class TicketEmptyScreenState extends State<TicketScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;

  @override
  void initState() {
    super.initState();
    AuthUtils.checkLogin(context);
    tabviewController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTicketsSection(context),
            Expanded(
              child: TabBarView(
                controller: tabviewController,
                children: const [
                  TicketUpcomingTabPage(),
                  TicketPastTabPage(),
                  AllTicketTabPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 44.h),
      decoration: AppDecoration.globalPrimary,
      child: Column(
        children: [
          CustomAppBar(
            title: AppbarTitle(
              text: AppVietnameseStrings.ticketsTitle,
              margin: EdgeInsets.symmetric(horizontal: 14.h, vertical: 22.h),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 14.h),
            child: TabBar(
              controller: tabviewController,
              labelPadding: EdgeInsets.zero,
              labelColor: Colors.white,
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
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: AppVietnameseStrings.upcomingTab),
                Tab(text: AppVietnameseStrings.pastTicketsTab),
                Tab(text: AppVietnameseStrings.allTab),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TicketPastTabPage extends StatefulWidget {
  const TicketPastTabPage({super.key});

  @override
  State<TicketPastTabPage> createState() => _TicketPastTabPageState();
}

class _TicketPastTabPageState extends State<TicketPastTabPage> {
  List pastEvents = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getPastEvents();
  }

  Future<void> getPastEvents() async {
    setState(() {
      isLoading = true;
    });
    final response = await ApiService.requestApi(
      'order/private/search-event',
      {"isPastTicket": true, "page": 0, "size": 99},
      useAuth: true,
    );

    if (!mounted) return;

    if (response != null && response['data'] != null) {
      setState(() {
        isLoading = false;

        pastEvents = response['data']['content'];
      });
    } else {
      print(AppVietnameseStrings.noDataFound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: getPastEvents,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
              child: pastEvents.isNotEmpty
                  ? ListView.separated(
                      itemCount: pastEvents.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final event = pastEvents[index];
                        return _buildTicketItem(event);
                      },
                    )
                  : Center(
                      child: Text(AppVietnameseStrings.noEvents,
                          style: theme.textTheme.titleMedium)),
            ));
  }
}

Widget _buildTicketItem(event) {
  String status;
  switch (event['status']) {
    case 0:
      status = AppVietnameseStrings.statusPendingPayment;
      break;
    case 1:
      status = AppVietnameseStrings.statusPaid;
      break;
    case 2:
      status = AppVietnameseStrings.statusPaymentFailed;
      break;
    default:
      status = AppVietnameseStrings.statusUndefined;
  }

  return Container(
    padding: EdgeInsets.all(8.h),
    // decoration: AppDecoration.outlineGray.copyWith(borderRadius: BorderRadiusStyle.roundedBorder4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(event['orderCode'], style: theme.textTheme.titleMedium),
        // Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(event['createdAt'])), style: theme.textTheme.bodySmall), // Định dạng ngày
        // Text("${event['totalAmount']} VND", style: CustomTextStyles.bodySmallBlack900),
        Text(status, style: theme.textTheme.bodySmall), // Hiển thị trạng thái
      ],
    ),
  );
}

class TicketUpcomingTabPage extends StatefulWidget {
  const TicketUpcomingTabPage({super.key});

  @override
  State<TicketUpcomingTabPage> createState() => _TicketUpcomingTabPageState();
}

class _TicketUpcomingTabPageState extends State<TicketUpcomingTabPage> {
  int? selectedIndex;
  List upcomingEvents = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getUpcomingEvent();
  }

  Future<void> getUpcomingEvent() async {
    setState(() {
      isLoading = true;
    });
    final response = await ApiService.requestApi(
      'order/private/search-event',
      {
        "isPastTicket": false,
        "page": 0,
        "size": 99,
      },
      useAuth: true,
    );
    if (!mounted) return;
    if (response != null && response['data'] != null) {
      setState(() {
        isLoading = false;
        upcomingEvents = response['data']['content'];
      });
    } else {
      print(AppVietnameseStrings.noDataFound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: getUpcomingEvent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 30.h),
              child: upcomingEvents.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: upcomingEvents.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final event = upcomingEvents[index];
                        final isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TicketPage(id: event["id"] ?? 0),
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? appTheme.green500 : Colors.white,
                              border: Border.all(
                                color: isSelected
                                    ? appTheme.greenA700
                                    : appTheme.gray300,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TicketItemWidget(event: event),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(AppVietnameseStrings.noEvents,
                          style: theme.textTheme.titleMedium)),
            ));
  }
}

class AllTicketTabPage extends StatefulWidget {
  const AllTicketTabPage({super.key});

  @override
  State<AllTicketTabPage> createState() => _AllTicketTabPageState();
}

class _AllTicketTabPageState extends State<AllTicketTabPage> {
  bool isLoading = false;
  List allEvents = [];

  @override
  void initState() {
    super.initState();
    getAllEvents();
  }

  Future<void> getAllEvents() async {
    setState(() {
      isLoading = true;
    });
    final response = await ApiService.requestApi(
      'order/private/search-event',
      {
        "isPastTicket": null,
        "page": 0,
        "size": 99,
      },
      useAuth: true,
    );
    if (response != null && response['data'] != null) {
      setState(() {
        isLoading = false;
        allEvents = response['data']['content'];
      });
    } else {
      print(AppVietnameseStrings.noDataFound);
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: getAllEvents,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 30.h),
              child: allEvents.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: allEvents.length,
                      itemBuilder: (context, index) {
                        final event = allEvents[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TicketPage(id: event["id"] ?? 0),
                                ));
                          },
                          child: TicketItemWidget(event: event),
                        );
                      },
                      separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    )
                  : Center(
                      child: Text(AppVietnameseStrings.noEvents,
                          style: theme.textTheme.titleMedium)),
            ));
  }
}

class TicketItemWidget extends StatelessWidget {
  final dynamic event;

  const TicketItemWidget({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outlineGray
          .copyWith(borderRadius: BorderRadiusStyle.roundedBorder4),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomImageView(
                        color: appTheme.greenA700,
                        imagePath: 'assets/images/empty_ticket.png',
                        width: 30.h,
                        height: 30.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                event != null
                                    ? event['eventDTO']['name']
                                    : "Tên sự kiện",
                                style: theme.textTheme.titleMedium),
                            Text(
                                event != null
                                    ? DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(event['createdAt']))
                                    : "Ngày & Giờ",
                                style: theme
                                    .textTheme.bodySmall), // Định dạng ngày
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    // child: Text(event != null ? "${event['totalAmount']} VND" : "2 vé", style: CustomTextStyles.bodySmallBlack900),
                    child: _buildTicketItem(event ?? 0),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 88.h,
            height: 84.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.h),
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                  'http://162.248.102.236:8055/assets/${event != null ? event['eventDTO']['eventPoster'] : 'default_image.png'}',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
