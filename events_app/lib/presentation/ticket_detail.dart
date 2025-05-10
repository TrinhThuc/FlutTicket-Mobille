import 'package:events_app/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../service/api_service.dart';
import '../src/localization/app_vietnamese_strings.dart';
import 'payment_screen.dart';
import 'web_view_screen.dart';

class TicketPage extends StatefulWidget {
  final int id;
  const TicketPage({super.key, this.id = 0});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  OrderData? orderData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchOrderData();
  }

  Future<void> fetchOrderData() async {
    try {
      final response = await ApiService.requestGetApi(
        'order/private/order/${widget.id}',
        useAuth: true,
      );
      print('API response: $response'); // Debug: in ra dữ liệu API
      if (response != null && response['data'] != null) {
        setState(() {
          orderData = OrderData.fromJson(response['data']);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = AppVietnameseStrings.errorNoDataReceived;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Lỗi parse JSON: $e');
      setState(() {
        errorMessage = '${AppVietnameseStrings.errorPrefix}: $e';
        isLoading = false;
      });
    }
  }

  Widget buildDetailRow(String title, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              detail,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSectionCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Divider(thickness: 1, color: Colors.grey[300]),
            ...children,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  fetchOrderData();
                },
                child: const Text(AppVietnameseStrings.retry),
              ),
            ],
          ),
        ),
      );
    }

    // Nếu dữ liệu đã được tải thành công
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(AppVietnameseStrings.ticketDetailTitle,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            
            buildSectionCard(AppVietnameseStrings.eventDetailSectionTitle, [
              buildDetailRow(AppVietnameseStrings.eventLabel, orderData!.event.name),
              buildDetailRow(
                  AppVietnameseStrings.dateTimeLabel,
                  DateFormat('dd/MM/yyyy HH:mm')
                      .format(DateTime.parse(orderData!.event.startTime))),
              buildDetailRow(AppVietnameseStrings.locationLabel, orderData!.event.location),
              buildDetailRow(AppVietnameseStrings.organizerLabel, orderData!.event.organizer),
            ]),
            // Order info section
            buildSectionCard(AppVietnameseStrings.orderInformationSectionTitle, [
              buildDetailRow(AppVietnameseStrings.fullName, orderData!.fullName),
              buildDetailRow(AppVietnameseStrings.emailLabel, orderData!.email),
              buildDetailRow(AppVietnameseStrings.phoneLabel, orderData!.phoneNumber),
              buildDetailRow(
                  AppVietnameseStrings.genderLabel, orderData!.gender == 1 ? AppVietnameseStrings.female : AppVietnameseStrings.male),
              buildDetailRow(
                  AppVietnameseStrings.statusLabel,
                  orderData!.status == '0'
                      ? AppVietnameseStrings.statusPendingPayment
                      : orderData!.status == '1'
                          ? AppVietnameseStrings.statusPaid
                          : orderData!.status == '2'
                              ? AppVietnameseStrings.statusPaymentFailed
                              : AppVietnameseStrings.statusUnknown),
              buildDetailRow(AppVietnameseStrings.paymentMethodLabel, orderData!.paymentMethod),
              buildDetailRow(AppVietnameseStrings.refIdLabel, orderData!.orderCode),
            ]),

            buildSectionCard(AppVietnameseStrings.ticketDetailsSectionTitle, [
              ...orderData!.tickets.map((ticket) => Row(
                    children: [
                      Expanded(
                        child: buildDetailRow(
                          ticket.ticketType,
                          '${ticket.quantity} x ${NumberFormat('#,###').format(ticket.price)}đ',
                        ),
                      ),
                      if (ticket.qrCode != null && ticket.qrCode!.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.qr_code, color: Colors.blue),
                          onPressed: () {
                            showImageQRDialog(context, ticket.qrCode!);
                          },
                        )
                      else
                        IconButton(
                          icon: const Icon(Icons.qr_code, color: Colors.grey),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(AppVietnameseStrings.noQrCodeForTicket)),
                            );
                          },
                        ),
                    ],
                  )),
              Divider(thickness: 1, color: Colors.grey[300]),
              buildDetailRow(AppVietnameseStrings.totalAmountLabel,
                  '${NumberFormat('#,###').format(orderData!.totalAmount)}đ'),
            ]),

            const SizedBox(height: 16),

            // ACTION BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Xử lý share
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(AppVietnameseStrings.shareEventButton)),
                            );
                          },
                          icon: const Icon(Icons.share),
                          label: const Text(AppVietnameseStrings.shareEventButton),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Xử lý tải xuống
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(AppVietnameseStrings.downloadButton)),
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: const Text(AppVietnameseStrings.downloadButton),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Hiển thị nút thanh toán nếu chưa thanh toán hoặc thất bại
                  if (orderData!.status == '0' || orderData!.status == '2')
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // showLoadingDialog(context); // 👈 Bắt đầu loading
                          try {
                            final vnpayRes = await ApiService.requestPostOder(
                              'payment/private/vn-pay',
                              {
                                "orderId": widget.id,
                              },
                              useAuth: true,
                            );
                            print("Chi tiết phản hồi từ server: $vnpayRes");

                            Navigator.pop(context); // 👈 Đóng loading dialog

                            if (vnpayRes != null &&
                                vnpayRes["data"]?['paymentUrl'] != null) {
                              final paymentUrl = vnpayRes["data"]['paymentUrl'];
//
                              Navigator.pop(
                                  context); // Chờ chắc chắn dialog đã đóng
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewPaymentScreen(
                                    paymentUrl: paymentUrl,
                                  ),
                                ),
                              );
                            } else {
                              showToast(AppVietnameseStrings.errorCreatingPaymentUrl);
                            }
                          } catch (e) {
                            Navigator.pop(
                                context); // 👈 Đóng loading dialog nếu lỗi
                            showToast(AppVietnameseStrings.errorOccurredCreatingPaymentUrl);
                            print("${AppVietnameseStrings.errorPrefix}: $e");
                          }
                        },
                        icon: const Icon(Icons.payment),
                        label: const Text(AppVietnameseStrings.checkOutButton),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Các lớp dữ liệu

class OrderData {
  final String fullName;
  final String email;
  final String phoneNumber;
  final int gender;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String orderCode;
  final List<Ticket> tickets;
  final Event event;

  OrderData({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.orderCode,
    required this.tickets,
    required this.event,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      gender: json['gender'] ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? '',
      paymentMethod: 'VNPAY',
      orderCode: json['orderCode'] ?? '',
      tickets: json['listOrderTicket'] != null
          ? (json['listOrderTicket'] as List)
              .map((t) => Ticket.fromJson(t))
              .toList()
          : [],
      event: json['eventDTO'] != null
          ? Event.fromJson(json['eventDTO'])
          : Event(name: '', location: '', startTime: '', organizer: ''),
    );
  }
}

class Ticket {
  final String ticketType;
  final double price;
  final int quantity;
  final String? qrCode; // Nullable

  Ticket({
    required this.ticketType,
    required this.price,
    required this.quantity,
    this.qrCode,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      ticketType: json['ticketType'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
      qrCode: json['qrCodeUrl'] as String?, // Trả về null nếu không có
    );
  }
}


class Event {
  final String name;
  final String location;
  final String startTime;
  final String organizer;

  Event({
    required this.name,
    required this.location,
    required this.startTime,
    required this.organizer,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      startTime: json['startTime'] ?? '',
      organizer: json['organizerDTO'] != null
          ? (json['organizerDTO']['name'] ?? '')
          : '',
    );
  }
}

void showImageQRDialog(BuildContext context, String imageUrl) {
  
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content:  Container(
            width: 180.h,
            height: 180.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  imageUrl,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(AppVietnameseStrings.closeButton),
        ),
      ],
    ),
  );
}
