import 'package:events_app/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app_theme.dart';
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTicketsSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16),
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
          SizedBox(height: 16),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 14),
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
              ))
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
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: events.isNotEmpty
                  ? ListView.separated(
                      itemCount: events.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return _buildTicketItem(event: event);
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

Widget _buildTicketItem({required event}) {
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
    padding: EdgeInsets.all(8),
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
  final List events;

  const TicketUpcomingTabPage({Key? key, required this.events})
      : super(key: key);

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
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              child: events.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: events.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        final isSelected = selectedIndex == index;
                        return _buildTicketItem(event: event);
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
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 30),
              child: events.isNotEmpty
                  ? ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: events.length,
                      separatorBuilder: (_, __) => SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return _buildTicketItem(event: event);
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
