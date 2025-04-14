import 'package:events_app/app_theme.dart';
import 'package:events_app/app_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Thêm thư viện để định dạng ngày tháng

import 'payment_screen.dart';

class BuyTicketScreen extends StatefulWidget {
  final Map<String, dynamic> eventDetails;

  const BuyTicketScreen({super.key, required this.eventDetails});

  @override
  State<BuyTicketScreen> createState() => _BuyTicketScreenState();
}

class _BuyTicketScreenState extends State<BuyTicketScreen> {
  int totalPrice = 0;
  Map<int, int> ticketQuantities = {}; // ticketId -> quantity

  void _updateQuantity(int index, int quantity) {
    final ticket = widget.eventDetails['listTicket'][index];
    final ticketId = ticket['id'];
    final price = (ticket['price'] as num?)?.toInt() ?? 0;

    setState(() {
      ticketQuantities[ticketId] = quantity;

      totalPrice = 0;
      ticketQuantities.forEach((ticketId, qty) {
        final ticketItem = widget.eventDetails['listTicket']
            .firstWhere((t) => t['id'] == ticketId);
        final itemPrice = (ticketItem['price'] as num?)?.toInt() ?? 0;
        totalPrice += itemPrice * qty;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    final ticketOptions = widget.eventDetails['listTicket'] ?? [];

    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: CustomAppBar(
        height: 56.h,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, color: Colors.black),
          )
        ],
      ),
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 6.h, right: 6.h, top: 36.h),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 18.h),
                        child: Column(
                          children: [
                            Text(
                              widget.eventDetails['name'] ??
                                  'Tên sự kiện không có',
                              style: theme.textTheme.titleLarge,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'Thời gian: ${widget.eventDetails['startTime'] != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.eventDetails['startTime'])) : 'Không có thông tin'}',
                              style: theme.textTheme.bodySmall,
                            ),
                            Text(
                              widget.eventDetails['location'] ??
                                  'Địa điểm không có',
                              style: theme.textTheme.bodySmall,
                            ),
                            SizedBox(height: 82.h),
                            Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return TicketPurchaseSectionItem(
                                    ticketOption: ticketOptions[index],
                                    onQuantityChanged: (qty) {
                                      _updateQuantity(index, qty);
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) => Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 9.0.h),
                                  child: Divider(
                                    height: 1.h,
                                    thickness: 1.h,
                                    color: appTheme.gray20001,
                                  ),
                                ),
                                itemCount: ticketOptions.length,
                              ),
                            ),
                            _buildVoucherInput(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 90.h,
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 22.h),
        decoration: AppDecoration.globalGrey,
        child: Row(
          children: [
            Icon(Icons.shopping_bag_outlined, size: 24.h),
            const Spacer(),
            Text(formatCurrencyVND(totalPrice),
                style: theme.textTheme.titleMedium),
            CustomElevatedButton(
              text: 'Mua',
              onPressed: () {
                bool hasTickets =
                    ticketQuantities.values.any((quantity) => quantity > 0);
                if (!hasTickets) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng chọn ít nhất 1 vé')),
                  );
                  return;
                }

                int firstSelectedTicketId = ticketQuantities.entries
                    .firstWhere((entry) => entry.value > 0)
                    .key;

                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                  return PaymentScreen(
                    ticketQuantities: ticketQuantities,
                    selectedTicketType: firstSelectedTicketId,
                    eventDetails: widget.eventDetails,
                    totalPrice: totalPrice,
                  );
                }));
              },
              height: 44.h,
              width: 192.h,
              margin: EdgeInsets.only(left: 22.h),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: appTheme.greenA700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildVoucherInput(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 18.h),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Nhập mã voucher',
          border: OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              // Xử lý mã voucher ở đây
            },
          ),
        ),
      ),
    );
  }
}

class TicketPurchaseSectionItem extends StatefulWidget {
  const TicketPurchaseSectionItem({
    super.key,
    required this.ticketOption,
    this.onQuantityChanged,
  });

  final Map<String, dynamic> ticketOption;
  final Function(int)? onQuantityChanged;

  @override
  State<TicketPurchaseSectionItem> createState() =>
      _TicketPurchaseSectionItemState();
}

class _TicketPurchaseSectionItemState extends State<TicketPurchaseSectionItem> {
  int selectedQuantity = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onQuantityChanged != null) {
        widget.onQuantityChanged!(selectedQuantity);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.ticketOption['ticketType'] ?? 'Loại vé không có',
                style: theme.textTheme.titleMedium),
            SizedBox(height: 10.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: formatCurrencyVND((widget.ticketOption['price'] as num?)?.toInt()),
                    style: CustomTextStyles.bodyLargeBlack900_1,
                  ),
                  
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 18.h),
              child: Text(
                'Bán đến: ${widget.ticketOption['saleEndTime'] != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.ticketOption['saleEndTime'])) : 'Không có thông tin'}',
                style: CustomTextStyles.bodySmallGray600_1,
              ),
            ),
          ],
        )),
        widget.ticketOption['soldQuantity'] >= widget.ticketOption['quantity']
            ? const Text('Sold Out!', style: TextStyle(color: Colors.grey))
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                  value: selectedQuantity,
                  hint: const Text('Chọn'),
                  items: [
                    const DropdownMenuItem(
                        value: 0, child: Text('0')), // or 'Chọn'
                    ...List.generate(
                      widget.ticketOption['quantity'] -
                          widget.ticketOption['soldQuantity'],
                      (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      ),
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedQuantity = value ?? 0;
                    });
                    widget.onQuantityChanged?.call(value ?? 0);
                  },
                )),
              ),
      ],
    );
  }
}
