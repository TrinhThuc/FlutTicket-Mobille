import 'dart:developer';

import 'package:events_app/app_theme.dart';
import 'package:events_app/app_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../service/api_service.dart';
import 'web_view_screen.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic> eventDetails; // Thêm trường này
  final int totalPrice; // Thêm trường này
  final Map<int, int> ticketQuantities;
  final dynamic selectedTicketType;

  const PaymentScreen({
    super.key,
    required this.eventDetails,
    required this.totalPrice,
    required this.ticketQuantities,
    required this.selectedTicketType,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
       bool _dialogDismissed = false;

  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int selectedMethod = 0; // Track selected payment method globally
  String? selectedGender;
  @override
  void initState() {
    super.initState();
    _getUserInfo(); // Gọi lấy thông tin user khi widget khởi tạo
  }

  Future<void> _getUserInfo() async {
    final response =
        await ApiService.requestGetApi('oauth/user/get', 'get-user-info');

    if (response != null) {
      setState(() {
        fullnameController.text = response['full_name'] ?? '';
        phoneController.text = response['phone'] ?? '';
        emailController.text = response['email'] ?? '';
        addressController.text = response['location'] ?? '';

        // Giới tính: từ số -> chuỗi
        final int genderCode = response['gender'] ?? -1;
        if (genderCode == 0) {
          selectedGender = 'Nam';
        } else if (genderCode == 1) {
          selectedGender = 'Nữ';
        } else {
          selectedGender = 'Khác';
        }

        genderController.text = selectedGender ?? '';
      });
    } else {
      print('Lỗi: Không nhận được dữ liệu user hợp lệ');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        leadingWidth: 33.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildEventDetails(),
                    SizedBox(height: 32.h),
                    _buildContactInfo(),
                    SizedBox(height: 32.h),
                    _buildPaymentMethods(),
                    SizedBox(height: 24.h),
                    _buildTermsAndConditions(),
                  ],
                ),
              ),
              _buildBottomPaymentBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// **Event Details**
  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('La Rosalia', style: theme.textTheme.titleLarge),
        SizedBox(height: 12.h),
        Text('Remaining time 20.32', style: CustomTextStyles.bodySmallRed400),
      ],
    );
  }

  /// **Contact Information Form**
  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Nhập các thông tin', style: theme.textTheme.titleMedium),
        SizedBox(height: 16.h),
        CustomTextFormField(
          controller: fullnameController,
          hintText: 'Họ và tên',
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
          validator: (value) => value!.isEmpty ? 'Nhập họ và tên' : null,
        ),
        SizedBox(height: 12.h),
        CustomTextFormField(
          controller: phoneController,
          hintText: 'Số điện thoại',
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
          validator: (value) => value!.isEmpty ? 'Nhập số điện thoại' : null,
        ),
        SizedBox(height: 12.h),
        Text('Giới tính', style: theme.textTheme.bodyLarge),
        SizedBox(height: 8.h),
        RadioListTile<String>(
          title: const Text('Nam'),
          value: 'Nam',
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value;
              genderController.text =
                  value!; // vẫn dùng controller để gửi đi API
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Nữ'),
          value: 'Nữ',
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value;
              genderController.text = value!;
            });
          },
        ),
        
        if (selectedGender == null)
          Padding(
            padding: EdgeInsets.only(left: 12.h),
            child: Text(
              'Vui lòng chọn giới tính',
              style: TextStyle(color: Colors.red, fontSize: 12.h),
            ),
          ),
        SizedBox(height: 12.h),
        CustomTextFormField(
          controller: emailController,
          hintText: 'Email',
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
          validator: (value) => value!.isEmpty ? 'Nhập email' : null,
        ),
        SizedBox(height: 12.h),
        CustomTextFormField(
          controller: addressController,
          hintText: 'Địa chỉ',
          contentPadding:
              EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
          validator: (value) => value!.isEmpty ? 'Nhập địa chỉ' : null,
        ),
      ],
    );
  }

  /// **Payment Methods**
  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Methods', style: theme.textTheme.titleMedium),
        SizedBox(height: 12.h),
        PaymentMethodTile(
          index: 0,
          selectedMethod: selectedMethod,
          onSelected: (value) {
            setState(() {
              selectedMethod = value;
            });
          },
        ),
      ],
    );
  }

  /// **Terms & Conditions**
  Widget _buildTermsAndConditions() {
    return Text(
      'By proceeding, you agree to the Terms & Conditions and Refund Policy.',
      style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  /// **Bottom Payment Bar**
  Widget _buildBottomPaymentBar() {
    List<String> paymentMethods = ['VNPay'];
    List<String> paymentIcons = [
      'assets/images/vnpay-logo.png',
    ];
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined),
                  SizedBox(width: 8.h),
                  Text(formatCurrencyVND(widget.totalPrice),
                      style: theme.textTheme.titleLarge),
                ],
              ),
              Flexible(
                child: ElevatedButton.icon(

onPressed: () async {
  if (selectedGender == null) {
    showToast("Vui lòng chọn giới tính");
    return;
  }

  if (_formKey.currentState!.validate()) {
    showLoadingDialog(context); // Show loading dialog

                      try {
                        int _genderToInt(String gender) {
                          switch (gender) {
                            case 'Nam':
                              return 1;
                            case 'Nữ':
                              return 0;
                            default:
                              return -1;
                          }
                        }

                        // 1. Gọi API tạo order
                        Map<String, dynamic> _buildOrderBody() {
                          return {
                            "eventId": widget.eventDetails["id"],
                            "listOrderTicketReq": widget
                                .ticketQuantities.entries
                                .where((entry) => entry.value > 0)
                                .map((entry) {
                              return {
                                "ticketId": entry.key,
                                "quantity": entry.value,
                              };
                            }).toList(),
                            "fullName": fullnameController.text,
                            "gender": _genderToInt(genderController.text),
                            "address": addressController.text,
                            "phoneNumber": phoneController.text,
                            "email": emailController.text,
                          };
                        }

                        print("Body: ${_buildOrderBody()}");
                        final orderRes = await ApiService.requestPostOder(
                          'saga/event/order/create-order',
                          _buildOrderBody(),
                          useAuth: true,
                        );
                        log("Chi tiết phản hồi từ server: $orderRes"); // 👈 THÊM DÒNG NÀY
                        if (orderRes == null) {
                          showToast("Không nhận được phản hồi từ server");
                          print("Không nhận được phản hồi từ server"); // 👈 THÊM DÒNG NÀY
                        } else if (orderRes['data']["id"] == null) {
                          print(
                              "Chi tiết lỗi từ server: $orderRes"); // 👈 THÊM DÒNG NÀY
                          showToast(
                              orderRes['message'] ?? "Tạo đơn hàng thất bại");
                          return;
                        }
                        if (orderRes != null && orderRes['data']["id"] != null) {
                          final orderId = orderRes['data']["id"];

                          // 2. Gọi API tạo URL thanh toán VNPAY
                          final vnpayRes = await ApiService.requestPostOder(
                            'payment/private/vn-pay',
                            {
                              "orderId": orderId,
                            },
                            useAuth: true,
                          );
                          print (
                              "Chi tiết phản hồi từ server: $vnpayRes"); // 👈 THÊM DÒNG NÀY
                          if (vnpayRes != null && vnpayRes["data"]?['paymentUrl'] != null) {
                            final paymentUrl = vnpayRes["data"]['paymentUrl'];

                            // 3. Mở WebView để người dùng thanh toán
if (!_dialogDismissed) {
            hideLoadingDialog(context);
            _dialogDismissed = true;
          }                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPaymentScreen(
                                  paymentUrl: paymentUrl,
                                ),
                              ),
                            );
                          } else {
                            showToast("Không tạo được URL thanh toán");
                          }
                        } else {
                          showToast("Tạo đơn hàng thất bại");
                        }
                      } catch (e) {
                        print("Error: $e");
                        showToast("Đã xảy ra lỗi khi thanh toán");
                      } finally {
if (!_dialogDismissed) {
        hideLoadingDialog(context);
      }
      // Optionally, reset the flag here if needed.
      _dialogDismissed = false;                      }
                    }
                  },

                  // icon: Image.asset(paymentIcons[selectedMethod], height: 24.h, width: 40.h, color: Colors.white),
                  label: Text(
                    "Pay with ${paymentMethods[selectedMethod]}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.h),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// **Payment Method Tile Widget**
class PaymentMethodTile extends StatelessWidget {
  final int index;
  final int selectedMethod;
  final Function(int) onSelected;

  const PaymentMethodTile({
    super.key,
    required this.index,
    required this.selectedMethod,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<String> paymentMethods = ['VNPay'];
    List<String> paymentIcons = [
      'assets/images/vnpay-logo.png',
    ];

    return GestureDetector(
      onTap: () => onSelected(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedMethod == index ? Colors.blue : Colors.grey.shade300,
            width: selectedMethod == index ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8.h),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: selectedMethod,
              onChanged: (value) => onSelected(value!),
              activeColor: Colors.blue,
            ),
            SizedBox(width: 12.h),
            Text(paymentMethods[index],
                style: CustomTextStyles.bodySmallBlack900),
            const Spacer(),
            Image.asset(paymentIcons[index], height: 24.h, width: 40.h),
          ],
        ),
      ),
    );
  }
}
