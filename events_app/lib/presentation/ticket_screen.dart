import 'package:events_app/app_utils.dart';
import 'package:events_app/presentation/ticket_detail.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện để định dạng ngày

import '../app_theme.dart';
import '../service/api_service.dart';

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
              text: 'Tickets',
              margin: EdgeInsets.symmetric(horizontal: 14.h, vertical: 22.h),
            ),
          ),
          SizedBox(height: 16.h),
          Container(
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
                Tab(text: 'Upcoming'),
                Tab(text: 'Past Tickets'),
                Tab(text: 'All'),
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

  @override
  void initState() {
    super.initState();
    getPastEvents();
  }

  Future<void> getPastEvents() async {
    final response = await ApiService.requestApi(
      'order/private/search-event',
      {
        "isPastTicket": true,
        "page": 0,
        "size": 99
      },
      useAuth: true,
    );

    if (!mounted) return;

    if (response != null && response['data'] != null) {
      setState(() {
        pastEvents = response['data']['content'];
      });
    } else {
      print('No data found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        : Center(child: Text('Không có sự kiện nào', style: theme.textTheme.titleMedium)),
    );
  }


}
  Widget _buildTicketItem(event) {
    String status;
    switch (event['status']) {
      case 0:
        status = 'Chờ thanh toán';
        break;
      case 1:
        status = 'Đã thanh toán';
        break;
      case 2:
        status = 'Thanh toán thất bại';
        break;
      default:
        status = 'Trạng thái không xác định';
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

  @override
  void initState() {
    super.initState();
    getUpcomingEvent();
  }

  Future<void> getUpcomingEvent() async {
    final response = await ApiService.requestApi(
      'order/private/search-event',
      {
        "isPastTicket": false,
        "page": 0,
        "size": 99,
      }, useAuth: true,
    );
    if (!mounted) return;
    if (response != null && response['data'] != null) {
      setState(() {
        upcomingEvents = response['data']['content'];
      });
    } else {
      print('No data found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => TicketPage(id: event["id"] ?? 0),
                  ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? appTheme.green500 : Colors.white,
                    border: Border.all(
                      color: isSelected ? appTheme.greenA700 : appTheme.gray300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TicketItemWidget(event: event),
                ),
              );
            },
          )
        : Center(child: Text('Không có sự kiện nào', style: theme.textTheme.titleMedium)),
    );
  }
}

class AllTicketTabPage extends StatefulWidget {
  const AllTicketTabPage({super.key});

  @override
  State<AllTicketTabPage> createState() => _AllTicketTabPageState();
}

class _AllTicketTabPageState extends State<AllTicketTabPage> {

  List allEvents = [];

  @override
  void initState() {
    super.initState();
    getAllEvents();
  }

  Future<void> getAllEvents() async {
    final response = await ApiService.requestApi(
      'order/private/search-event',
      {
        "isPastTicket": null,
        "page": 0,
        "size": 99,
      }, useAuth: true,
    );
    if (response != null && response['data'] != null) {
      setState(() {
        allEvents = response['data']['content'];
      });
    } else {
      print('No data found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 30.h),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemCount: allEvents.length,
        itemBuilder: (context, index) {
          final event = allEvents[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => TicketPage(id:  event["id"] ?? 0),
              ));
            },
            child: TicketItemWidget(event: event),
          );
        },
        separatorBuilder: (_, __) => SizedBox(height: 8.h),
      ),
    );
  }
}

class TicketItemWidget extends StatelessWidget {
  final dynamic event;

  const TicketItemWidget({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecoration.outlineGray.copyWith(borderRadius: BorderRadiusStyle.roundedBorder4),
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
                      // Image.network(
                      //   event != null ? event['eventPoster'] : 'https://example.com/default_image.png',
                      //   width: 30.h,
                      //   height: 30.h,
                      //   fit: BoxFit.cover,
                      // ),
                      SizedBox(width: 8.h),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event != null ? event['orderCode'] : "Tên sự kiện", style: theme.textTheme.titleMedium),
                            Text(event != null ? DateFormat('dd/MM/yyyy').format(DateTime.parse(event['createdAt'])) : "Ngày & Giờ", style: theme.textTheme.bodySmall), // Định dạng ngày
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.h),
                    // child: Text(event != null ? "${event['totalAmount']} VND" : "2 vé", style: CustomTextStyles.bodySmallBlack900),
                    child: _buildTicketItem(event != null ? event : 0),
                  ),
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: 'assets/images/placeholder.png',
            height: 96.h,
            width: 140.h,
            radius: BorderRadius.horizontal(right: Radius.circular(5.h)),
          ),
        ],
      ),
    );
  }
}