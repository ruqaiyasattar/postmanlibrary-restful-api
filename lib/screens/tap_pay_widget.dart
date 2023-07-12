import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKQueryConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSDKSavedCardInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkApms.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';

class PayTapWidget extends StatefulWidget {
  const PayTapWidget({super.key});

  @override
  _PayTapWidget createState() => _PayTapWidget();
}

class _PayTapWidget extends State<PayTapWidget> {
  final String _instructions = 'Tap on "Pay" Button to try PayTabs plugin';

  @override
  void initState() {
    super.initState();
  }

  PaymentSdkConfigurationDetails generateConfig() {
    var billingDetails = BillingDetails("John Smith", "email@domain.com",
        "+97311111111", "st. 12", "eg", "dubai", "dubai", "12345");

    var shippingDetails = ShippingDetails("John Smith", "email@domain.com",
        "+97311111111", "st. 12", "eg", "dubai", "dubai", "12345");

    List<PaymentSdkAPms> apms = [];
    apms.add(PaymentSdkAPms.AMAN);
    var configuration = PaymentSdkConfigurationDetails(
        profileId: "*profile id*",
        serverKey: "*server key*",
        clientKey: "*client key*",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        screentTitle: "Pay with Card",
        amount: 20.0,
        showBillingInfo: true,
        forceShippingInfo: false,
        currencyCode: "EGP",
        merchantCountryCode: "EG",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        alternativePaymentMethods: apms,
        linkBillingNameWithCardHolderName: true);

    var theme = IOSThemeConfigurations();

    theme.logoImage = "assets/logo.png";

    configuration.iOSThemeConfigurations = theme;
    configuration.tokeniseType = PaymentSdkTokeniseType.MERCHANT_MANDATORY;
    return configuration;
  }

  Future<void> payPressed() async {
    FlutterPaytabsBridge.startCardPayment(generateConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          debugPrint(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            debugPrint("successful transaction");
            if (transactionDetails["isPending"]) {
              debugPrint("transaction pending");
            }
          } else {
            debugPrint("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          debugPrint("error");
          // Handle error here.
        } else if (event["status"] == "event") {
          debugPrint("event");
          // Handle events here.
        }
      });
    });
  }

  Future<void> payWithTokenPressed() async {
    FlutterPaytabsBridge.startTokenizedCardPayment(
        generateConfig(), "*Token*", "*TransactionReference*", (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          debugPrint(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            debugPrint("successful transaction");
            if (transactionDetails["isPending"]) {
              debugPrint("transaction pending");
            }
          } else {
            debugPrint("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> payWith3ds() async {
    FlutterPaytabsBridge.start3DSecureTokenizedCardPayment(
        generateConfig(),
        PaymentSDKSavedCardInfo("4111 11## #### 1111", "visa"),
        "*Token*", (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          debugPrint(transactionDetails);
          if (transactionDetails["isSuccess"]) {
            debugPrint("successful transaction");
            if (transactionDetails["isPending"]) {
              debugPrint("transaction pending");
            }
          } else {
            debugPrint("failed transaction");
          }

          // print(transactionDetails["isSuccess"]);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> payWithSavedCards() async {
    FlutterPaytabsBridge.startPaymentWithSavedCards(generateConfig(), false,
            (event) {
          setState(() {
            if (event["status"] == "success") {
              // Handle transaction details here.
              var transactionDetails = event["data"];
              debugPrint(transactionDetails);
              if (transactionDetails["isSuccess"]) {
                debugPrint("successful transaction");
                if (transactionDetails["isPending"]) {
                  debugPrint("transaction pending");
                }
              } else {
                debugPrint("failed transaction");
              }

              // print(transactionDetails["isSuccess"]);
            } else if (event["status"] == "error") {
              // Handle error here.
            } else if (event["status"] == "event") {
              // Handle events here.
            }
          });
        });
  }

  Future<void> apmsPayPressed() async {
    FlutterPaytabsBridge.startAlternativePaymentMethod(generateConfig(),
            (event) {
          setState(() {
            if (event["status"] == "success") {
              // Handle transaction details here.
              var transactionDetails = event["data"];
              debugPrint(transactionDetails);
            } else if (event["status"] == "error") {
              // Handle error here.
            } else if (event["status"] == "event") {
              // Handle events here.
            }
          });
        });
  }

  Future<void> queryPressed() async {
    FlutterPaytabsBridge.queryTransaction(
        generateConfig(), generateQueryConfig(), (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          debugPrint(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> applePayPressed() async {
    var configuration = PaymentSdkConfigurationDetails(
        profileId: "*Profile id*",
        serverKey: "*server key*",
        clientKey: "*client key*",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        amount: 20.0,
        currencyCode: "AED",
        merchantCountryCode: "ae",
        merchantApplePayIndentifier: "merchant.com.bunldeId",
        simplifyApplePayValidation: true);
    FlutterPaytabsBridge.startApplePayPayment(configuration, (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          debugPrint(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Widget applePayButton() {
    if (Platform.isIOS) {
      return TextButton(
        onPressed: () {
          applePayPressed();
        },
        child: const Text('Pay with Apple Pay'),
      );
    }
    return const SizedBox(height: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PayTabs Plugin Example App'),
        ),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(_instructions),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      payPressed();
                    },
                    child: const Text('Pay with Card'),
                  ),
                  TextButton(
                    onPressed: () {
                      payWithTokenPressed();
                    },
                    child: const Text('Pay with Token'),
                  ),
                  TextButton(
                    onPressed: () {
                      payWith3ds();
                    },
                    child: const Text('Pay with 3ds'),
                  ),
                  TextButton(
                    onPressed: () {
                      payWithSavedCards();
                    },
                    child: const Text('Pay with saved cards'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      apmsPayPressed();
                    },
                    child: const Text('Pay with Alternative payment methods'),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      queryPressed();
                    },
                    child: const Text('Query transaction'),
                  ),
                  const SizedBox(height: 16),
                  applePayButton()
                ])),
      ),
    );
  }

  PaymentSDKQueryConfiguration generateQueryConfig() {
    return PaymentSDKQueryConfiguration("ServerKey", "ClientKey",
        "Country Iso 2", "Profile Id", "Transaction Reference");
  }
}