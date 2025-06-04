import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart'; // Import
import '../utils/auth_utils.dart';

class TicketScreen extends StatefulWidget {
  const TicketScreen({Key? key}) : super(key: key);

  @override
  State<TicketScreen> createState() => TicketEmptyScreenState();
}

class TicketEmptyScreenState extends State<TicketScreen>
    with TickerProviderStateMixin {
  late TabController tabviewController;
  bool isLoading = false;
  List upcomingEvents = [];
  List pastEvents = [];
  List allEvents = [];

  @override
  void initState() {
    super.initState(); 
    AuthUtils.checkLogin(context);
    tabviewController = TabController(length: 3, vsync: this);
   
    refreshData();
  }

  void refreshData() {
    if (mounted) {
      setState(() {
        // Refresh tất cả các tab
        getUpcomingEvent();
        getPastEvents();
        getAllEvents();
      });
    }
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
      }, useAuth: true,
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

  Future<void> getPastEvents() async {
    setState(() {
      isLoading = true;
    });
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
        isLoading = false;
        pastEvents = response['data']['content'];
      });
    } else {
      print(AppVietnameseStrings.noDataFound);
    }
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
      }, useAuth: true,
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTicketsSection(context),
            Expanded(
              child: TabBarView(
                controller: tabviewController,
                children: [
                  TicketUpcomingTabPage(events: upcomingEvents),
                  TicketPastTabPage(events: pastEvents),
                  AllTicketTabPage(events: allEvents),
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
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vé của tôi',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          TabBar(
            controller: tabviewController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Sắp tới'),
              Tab(text: 'Đã qua'),
              Tab(text: 'Tất cả'),
            ],
          ),
        ],
      ),
    );
  }
}

class TicketPastTabPage extends StatefulWidget {
  final List events;

  const TicketPastTabPage({Key? key, required this.events}) : super(key: key);

  @override
  State<TicketPastTabPage> createState() => _TicketPastTabPageState();
}

class _TicketPastTabPageState extends State<TicketPastTabPage> {
  late List events;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    events = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              // Implement refresh logic
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
              child: events.isNotEmpty 
                ? ListView.separated(
                    itemCount: events.length,
                    separatorBuilder: (_, __) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return TicketItemWidget(event: event);
                    },
                  )
                : Center(
                    child: Text(
                      AppVietnameseStrings.noDataFound,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
            ),
          );
  }
}

class TicketItemWidget extends StatelessWidget {
  final dynamic event;

  const TicketItemWidget({
    Key? key,
    required this.event,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String status;
    Color statusColor;
    Color backgroundColor;

    switch (event['status']) {
      case 'ACTIVE':
        status = 'Đang hoạt động';
        statusColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        break;
      case 'CANCELLED':
        status = 'Đã hủy';
        statusColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        break;
      case 'COMPLETED':
        status = 'Hoàn thành';
        statusColor = Colors.blue;
        backgroundColor = Colors.blue.withOpacity(0.1);
        break;
      default:
        status = 'Không xác định';
        statusColor = Colors.grey;
        backgroundColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event['eventName'] ?? '',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            event['eventDate'] ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            event['venue'] ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class TicketUpcomingTabPage extends StatefulWidget {
  final List events;

  const TicketUpcomingTabPage({Key? key, required this.events}) : super(key: key);

  @override
  State<TicketUpcomingTabPage> createState() => _TicketUpcomingTabPageState();
}

class _TicketUpcomingTabPageState extends State<TicketUpcomingTabPage> {
  late List events;
  int? selectedIndex;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    events = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              // Implement refresh logic
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 30.h),
              child: events.isNotEmpty 
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final isSelected = selectedIndex == index;
                      return TicketItemWidget(event: event);
                    },
                  )
                : Center(
                    child: Text(
                      AppVietnameseStrings.noDataFound,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
            ),
          );
  }
}

class AllTicketTabPage extends StatefulWidget {
  final List events;

  const AllTicketTabPage({Key? key, required this.events}) : super(key: key);

  @override
  State<AllTicketTabPage> createState() => _AllTicketTabPageState();
}

class _AllTicketTabPageState extends State<AllTicketTabPage> {
  late List events;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    events = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              // Implement refresh logic
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 30.h),
              child: events.isNotEmpty 
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: events.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8.h),
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return TicketItemWidget(event: event);
                    },
                  )
                : Center(
                    child: Text(
                      AppVietnameseStrings.noDataFound,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
            ),
          );
  }
}