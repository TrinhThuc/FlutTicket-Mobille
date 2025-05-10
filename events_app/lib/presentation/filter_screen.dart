import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart';

class FilterScreen extends StatefulWidget {
  final Map<String, dynamic>? initialFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterScreen({
    super.key,
    this.initialFilters,
    required this.onFiltersApplied,
  });

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late TextEditingController _searchContentController;
  late TextEditingController _locationController;
  DateTime? _startDate;
  DateTime? _endDate;
  int? _selectedEventTypeId;
  List<Map<String, dynamic>> _eventTypes = [];

  @override
  void initState() {
    super.initState();
    _searchContentController = TextEditingController(text: widget.initialFilters?['searchContent'] ?? '');
    _locationController = TextEditingController(text: widget.initialFilters?['location'] ?? '');
    _startDate = widget.initialFilters?['startDate'] != null 
        ? DateFormat('dd/MM/yyyy').parse(widget.initialFilters!['startDate'])
        : null;
    _endDate = widget.initialFilters?['endDate'] != null 
        ? DateFormat('dd/MM/yyyy').parse(widget.initialFilters!['endDate'])
        : null;
    _selectedEventTypeId = widget.initialFilters?['eventTypeId'];
    _getEventTypes();
  }

  Future<void> _getEventTypes() async {
    final response = await ApiService.requestGetApi(
        'event/public/get-event-type');

    if (response != null) {
      setState(() {
        _eventTypes = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now()),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _applyFilters() {


    final filters = <String, dynamic>{
    };

    // Chỉ thêm filter khi có giá trị thực sự
    if (_selectedEventTypeId != null) {
      filters['eventTypeId'] = _selectedEventTypeId;
    }

    if (_startDate != null) {
      filters['startDate'] = DateFormat('dd/MM/yyyy').format(_startDate!);
    }

    if (_endDate != null) {
      filters['endDate'] = DateFormat('dd/MM/yyyy').format(_endDate!);
    }

    final location = _locationController.text.trim();
    if (location.isNotEmpty) {
      filters['location'] = location;
    }

    final searchContent = _searchContentController.text.trim();
    if (searchContent.isNotEmpty) {
      filters['searchContent'] = searchContent;
    }

    widget.onFiltersApplied(filters);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(AppVietnameseStrings.filtersTitle),
        actions: [
          TextButton(
            onPressed: _applyFilters,
            child: const Text(AppVietnameseStrings.applyButton),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: _eventTypes.any((type) => type['id'] == _selectedEventTypeId) ? _selectedEventTypeId : null,
              decoration: const InputDecoration(
                labelText: AppVietnameseStrings.eventTypeLabel,
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<int>(
                  value: null,
                  child: Text(AppVietnameseStrings.allEventTypes),
                ),
                ..._eventTypes.map((type) {
                  return DropdownMenuItem<int>(
                    value: type['id'],
                    child: Text(type['name']),
                  );
                }),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedEventTypeId = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: AppVietnameseStrings.locationFilterLabel,
                border: OutlineInputBorder(),
                hintText: AppVietnameseStrings.enterLocationHint,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppVietnameseStrings.plsEnterLocation;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDate(context, true),
                    child: Text(
                      _startDate != null
                          ? '${AppVietnameseStrings.startDateFilterPrefix}${DateFormat('dd/MM/yyyy').format(_startDate!)}'
                          : AppVietnameseStrings.selectStartDateButton,
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDate(context, false),
                    child: Text(
                      _endDate != null
                          ? '${AppVietnameseStrings.endDateFilterPrefix}${DateFormat('dd/MM/yyyy').format(_endDate!)}'
                          : AppVietnameseStrings.selectEndDateButton,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _searchContentController,
              decoration: const InputDecoration(
                labelText: AppVietnameseStrings.searchContentLabel,
                border: OutlineInputBorder(),
                hintText: AppVietnameseStrings.enterSearchContentHint,
              ),
            ),
            const SizedBox(height: 16),
           
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchContentController.dispose();
    _locationController.dispose();

    super.dispose();
  }
} 