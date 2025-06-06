import 'package:events_app/presentation/single_event_screen.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart';
import 'filter_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List events = [];
  Map<String, dynamic> filters = {};
  List<Map<String, dynamic>> eventTypes = [];

  @override
  void initState() {
    super.initState();
    _getPopularEvents();
    _getEventTypes();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _getPopularEvents() async {
    try {
      final response = await ApiService.requestGetApi('event/public/get-popular-event');
      
      if (response != null && response['data'] != null && response['data']['content'] != null) {
        setState(() {
          events = response['data']['content'];
        });
      } else {
        setState(() {
          events = [];
        });
        print(AppVietnameseStrings.errorNoPopularEvents);
      }
    } catch (e) {
      print('Error getting popular events: $e');
      setState(() {
        events = [];
      });
    }
  }

  Future<void> _getEventTypes() async {
    try {
      final response = await ApiService.requestGetApi('event/public/get-event-type');
      
      if (response != null && response['data'] != null) {
        setState(() {
          eventTypes = List<Map<String, dynamic>>.from(response['data']);
        });
      } else {
        setState(() {
          eventTypes = [];
        });
        print(AppVietnameseStrings.errorNoEventTypes);
      }
    } catch (e) {
      print('Error getting event types: $e');
      setState(() {
        eventTypes = [];
      });
    }
  }

  void _onSearchChanged() {
    // Xử lý sự kiện khi gõ vào searchController
    final query = searchController.text;
    if (query.isNotEmpty) {
      _searchEvents(query);
    } else {
      _getPopularEvents();
    }
  }

  Future<void> _searchEvents(String query) async {
    try {
      final response = await ApiService.requestApi(
          'event/public/search-event?sort=name,asc', {});

      if (response != null && response['data'] != null && response['data']['content'] != null) {
        setState(() {
          events = response['data']['content'];
        });
      } else {
        setState(() {
          events = [];
        });
        print(AppVietnameseStrings.errorNoSearchResults);
      }
    } catch (e) {
      print('Error searching events: $e');
      setState(() {
        events = [];
      });
    }
  }

  void refreshData() {
    setState(() {
      // Gọi lại các hàm load dữ liệu
      _getPopularEvents();
      _getEventTypes();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CustomSearchView(
                  controller: searchController,
                  hintText: AppVietnameseStrings.searchForHint,
                  contentPadding: const EdgeInsets.only(
                    left: 12,
                    top: 6,
                    bottom: 6,
                  ),
                  onChanged: (value) {
                    setState(() {
                      filters['searchContent'] = value;
                    });
                    _searchEventsWithFilters(); // Gọi tìm kiếm với bộ lọc sau khi nhập
                  },
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.search, size: 20),
                  )),
            ),
            const SizedBox(height: 12),

            // Filters Section
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(AppVietnameseStrings.filtersTitle,
                            style: CustomTextStyles.titleMediumSemiBold),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilterScreen(
                                  initialFilters: filters,
                                  onFiltersApplied: (newFilters) {
                                    setState(() {
                                      filters = newFilters;
                                      _searchEventsWithFilters();
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.filter_list),
                          label: const Text(AppVietnameseStrings.openFiltersButton),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        if (filters['eventTypeId'] != null)
                          FilterChipviewItemWidget(
                            label:
                                '${AppVietnameseStrings.eventTypeFilterPrefix}${_getEventTypeName(filters['eventTypeId'])}',
                            onSelected: (selected) {
                              setState(() {
                                filters['eventTypeId'] = null;
                                _searchEventsWithFilters();
                              });
                            },
                          ),
                        if (filters['startDate'] != null)
                          FilterChipviewItemWidget(
                            label: '${AppVietnameseStrings.startDateFilterPrefix}${filters['startDate']}',
                            onSelected: (selected) {
                              setState(() {
                                filters['startDate'] = null;
                                _searchEventsWithFilters();
                              });
                            },
                          ),
                        if (filters['endDate'] != null)
                          FilterChipviewItemWidget(
                            label: '${AppVietnameseStrings.endDateFilterPrefix}${filters['endDate']}',
                            onSelected: (selected) {
                              setState(() {
                                filters['endDate'] = null;
                                _searchEventsWithFilters();
                              });
                            },
                          ),
                        if (filters['location'] != null)
                          FilterChipviewItemWidget(
                            label: '${AppVietnameseStrings.locationFilterPrefix}${filters['location']}',
                            onSelected: (selected) {
                              setState(() {
                                filters['location'] = null;
                                _searchEventsWithFilters();
                              });
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.maxFinite,
                margin: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: double.maxFinite,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${events.length}${AppVietnameseStrings.eventsSuffix}',
                              style: CustomTextStyles.bodyLargeBlack900),
                          const Spacer(),
                          Text(AppVietnameseStrings.sortByRelevant,
                              style: CustomTextStyles.bodySmallBlack900),
                          const Icon(
                            Icons.arrow_drop_down,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: events.length,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 18);
                          },
                          itemBuilder: (context, index) {
                            final event = events[index];
                            return event['name'] != null ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EventPage(eventId: event['id'] ?? 0),
                                  ),
                                );
                              },
                              child: EventListItemWidget(event: event),
                            ) :
                            Center(child: Text(AppVietnameseStrings.noEvents));
                          },
                        ),
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

  String _getEventTypeName(int? eventTypeId) {
    if (eventTypeId == null) return '';
    final eventType = eventTypes.firstWhere(
      (type) => type['id'] == eventTypeId,
      orElse: () => {'name': 'Không xác định'},
    );
    return eventType['name'];
  }

  Future<void> _searchEventsWithFilters() async {
    // Tạo query string từ các filter
    final queryParams = <String, String>{};

    // if (filters['eventTypeId'] != null) {
    //   queryParams['eventTypeId'] = filters['eventTypeId'].toString();
    // }
    // if (filters['startDate'] != null) {
    //   queryParams['startDate'] = filters['startDate'];
    // }
    // if (filters['endDate'] != null) {
    //   queryParams['endDate'] = filters['endDate'];
    // }
    // if (filters['location'] != null) {
    //   queryParams['location'] = filters['location'];
    // }
    // if (filters['searchContent'] != null) {
    //   queryParams['searchContent'] = filters['searchContent'];
    // }
    final Map<String, dynamic> body = {};

  if (filters['eventTypeId'] != null) {
    body['eventTypeId'] = filters['eventTypeId'];
  }
  if (filters['startDate'] != null) {
    body['startDate'] = filters['startDate'];
  }
  if (filters['endDate'] != null) {
    body['endDate'] = filters['endDate'];
  }
  if (filters['location'] != null) {
    body['location'] = filters['location'];
  }
  if (filters['searchContent'] != null) {
    body['searchContent'] = filters['searchContent'];
  }
    body['page'] = filters['page'] ?? 0;
  body['size'] = filters['size'] ?? 99;

    queryParams['sort'] = 'name,asc';

    // Tạo URL với query parameters
    final queryString = Uri(queryParameters: queryParams).query;
    final url = 'event/public/search-event?$queryString';
  final response = await ApiService.requestApi(
    url,
    body,
  );

    if (response != null) {
      setState(() {
        events = response['data']['content'] ?? [];
      });
    } else {
      print(AppVietnameseStrings.errorNoSearchResults);
      setState(() {
        events = [];
      });
    }
  }
}

class EventListItemWidget extends StatefulWidget {
  final Map<String, dynamic> event;

  const EventListItemWidget({super.key, required this.event});

  @override
  State<EventListItemWidget> createState() => _EventListItemWidgetState();
}

class _EventListItemWidgetState extends State<EventListItemWidget> {
  @override
  Widget build(BuildContext context) {
    print('Event List assets:${widget.event['eventPoster']}');
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)  => EventPage(eventId: widget.event['id']),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'http://162.248.102.236:8055/assets/${widget.event['eventPoster']}',
              width: 88,
              height: 84,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => CustomImageView(
                imagePath: 'assets/images/No-Image.png',
                width: 88,
                height: 84,
                fit: BoxFit.cover,
                radius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEE, MMM d · HH:mm a')
                      .format(DateTime.parse(widget.event['startTime'])),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.event['name'],
                  style: CustomTextStyles.titleMediumGray900_1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        widget.event['location'],
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
          Column(
            children: [
              IconButton(
                icon: Icon(
                  widget.event['isFav'] == true
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: widget.event['isFav'] == true
                      ? Colors.red
                      : appTheme.gray900,
                  size: 18,
                ),
                onPressed: () {
                  ApiService.requestApi(
                    widget.event['isFav']
                        ? 'event/private/remove-favourite-event/${widget.event['id']}'
                        : 'event/private/add-favourite-event/${widget.event['id']}',
                    {},
                    useAuth: true,
                  ).then((response) {
                    if (response != null) {
                      setState(() {
                        widget.event['isFav'] = !widget.event['isFav'];
                      });
                    }
                  });
                },
              ),
              const Icon(Icons.share, color: Colors.grey, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}

/// **🔹 Filter Chip Widget**
class FilterChipviewItemWidget extends StatelessWidget {
  final String label;
  final Function(bool) onSelected;

  const FilterChipviewItemWidget({
    super.key,
    required this.label,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: const EdgeInsets.only(left: 12, top: 4, bottom: 4),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        label,
        style: TextStyle(
          color: appTheme.black900,
          fontSize: 12,
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
          side: BorderSide.none, borderRadius: BorderRadius.circular(5)),
      onSelected: onSelected,
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
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:
                Image.asset(imageUrl, width: 88, height: 84, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: theme.textTheme.bodySmall),
                Text(title, style: CustomTextStyles.titleMediumGray900_1),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
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
          const SizedBox(width: 12),
          const Icon(Icons.share, color: Colors.grey),
        ],
      ),
    );
  }
}
