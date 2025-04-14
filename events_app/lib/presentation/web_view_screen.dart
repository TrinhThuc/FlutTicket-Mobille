import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const WebViewPaymentScreen({super.key, required this.paymentUrl});

  @override
  State<WebViewPaymentScreen> createState() => _WebViewPaymentScreenState();
}

class _WebViewPaymentScreenState extends State<WebViewPaymentScreen> {
  late final WebViewController _controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains("vnp_ResponseCode")) {
              final uri = Uri.parse(request.url);
              final responseCode = uri.queryParameters['vnp_ResponseCode'];
              log("Response URL: ${request.url}");
              log("Parsed URI: $uri");

              // Gọi API callback từ server
              await _callCallbackUrl(uri);

              if (responseCode == '00') {
                showToast("Thanh toán thành công");
                Navigator.of(context).popUntil((route) => route.isFirst);
              } else {
                showToast("Thanh toán thất bại hoặc bị huỷ");
                Navigator.pop(context);
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageFinished: (String url) {
            setState(() => isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  Future<void> _callCallbackUrl(Uri callbackUri) async {
    try {
      // Gọi GET request đến callback URL (có thể thay đổi sang POST nếu server yêu cầu)
      final response = await http.get(callbackUri);
      log("Callback response status: ${response.statusCode}");
      log("Callback response body: ${response.body}");
    } catch (e) {
      log("Lỗi khi gọi callback URL: $e");
      showToast("Lỗi khi xác nhận thanh toán từ server");
    }
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán VNPay")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
