import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:payment_integration/paystack/auth_response.dart';
import 'package:payment_integration/paystack/transaction.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String amount;
  final String email;
  final String reference;
  const PaymentScreen({
    super.key,
    required this.amount,
    required this.email,
    required this.reference,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // a function to create transaction
  Future<AuthResponse> creatTransaction(Transaction transaction) async {
    const String url = 'https://api.paystack.co/transaction/initialize';
    const String secretKey = '';
    final data = transaction.toJson();

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print('TestResponse: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // print('TestResponse: ${AuthResponse.fromJson(responseData['data'])}');
        return AuthResponse.fromJson(responseData['data']);
      } else {
        throw 'Payment unsuccessful';
      }
    } on Exception {
      throw 'Payment unsuccessful';
    }
  }

  Future<String> initializeTransaction() async {
    final price = double.parse(widget.amount);
    final transaction = Transaction(
        amount: (price * 100).toString(),
        email: widget.email,
        reference: widget.reference,
        channel: ['mobile_money'],
        currency: 'GHS');
    try {
      final response = await creatTransaction(transaction);
      return response.authorizationUrl;
    } catch (e) {
      print('Error Initialization Transaction: $e');
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<String>(
              future: initializeTransaction(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print('TestUrl: ${snapshot.data}');
                  final url = snapshot.data;
                  return WebViewWidget(
                    controller: WebViewController()
                      ..setJavaScriptMode(JavaScriptMode.unrestricted)
                      ..setNavigationDelegate(
                        NavigationDelegate(
                          onProgress: (int progress) {
                            // Update loading bar.
                          },
                          onPageStarted: (String url) {},
                          onPageFinished: (String url) {},
                          onHttpError: (HttpResponseError error) {},
                          onWebResourceError: (WebResourceError error) {},
                          onNavigationRequest: (NavigationRequest request) {
                            if (request.url
                                .startsWith('https://www.youtube.com/')) {
                              return NavigationDecision.prevent;
                            }
                            return NavigationDecision.navigate;
                          },
                        ),
                      )
                      ..loadRequest(
                        Uri.parse(url!),
                      ),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              })),
    );
  }
}
