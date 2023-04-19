// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:iframe_cashpay_plugin/iFrameCashPay.dart';

void main() {
  runApp(PayMaterialApp());
}

class PayMaterialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay for Flutter Demo',
      home: PaySampleApp(),
    );
  }
}

class PaySampleApp extends StatefulWidget {
  PaySampleApp({Key? key}) : super(key: key);

  @override
  _PaySampleAppState createState() => _PaySampleAppState();
}

class _PaySampleAppState extends State<PaySampleApp> {
  List<BeneficiaryList>? beneficiaryList = [];
  String? title = "PaySampleApp";
  bool? check1 = false;
  String desc = "";
  //Token returned from Response login
  //Documentation https://documenter.getpostman.com/view/17550185/2s93XzwN9o
  String token =
      "TFBVaHAwQWoydjNabXdpMXlRTGxXSytncE9rTWdocFk5c1JndHpKVTdiODNYelAiLCJNU0lTRE4iOiJNYXplbi5jby50c3QiLCJuYmYiOjE2ODE4NDc5MTQsImV4cCI6MTY4MTg1MDkxNCwiaWF0IjoxNjgxODQ3OTE0LCJpc3MiOiJodHRwczovL3d3dy50YW1rZWVuLmNvbS55ZS9DYXNoIiwiYXVkIjoiaHR0cDovL3d3dy50YW1rZWVuLmNvbS55ZS9DYXNoIn0.7DnKT2dzKlVPOEkweNizvy-JimsfTayiBCpedCIFZzY";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        backgroundColor: Colors.white,
        body: ListView(children: [
          CheckboxListTile(
            title: const Text(
              'ساعة 5000ريال',
              textDirection: TextDirection.rtl,
            ),
            value: check1,
            onChanged: (bool? value) {
              onChackWristwatch(value!, 5000, "ساعة,");
            },
            secondary: const Icon(Icons.help),
          ),
          ElevatedButton(
              child: const Text('الدفع عبر كاش باي'),
              onPressed: () async {
                (beneficiaryList!.isNotEmpty)
                    ? await createOrder(token)
                        .then((value) => value.ResultCode == 1
                            ? showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(25.0),
                                          topRight: Radius.circular(25.0),
                                        ),
                                      ),
                                      //BottomSheetIframeCashPay SDK to use iFrame CashPay
                                      child: iFrameCashPay(
                                        iframeURL: value.iframeURL,
                                        onConfirmPayment: onConfirmPayment,
                                      ));
                                })
                            : null)
                    : null;
              })
        ]));
  }

  onConfirmPayment(message) {
    if (message.message == "Confirmation" || message.message == "NEEDTOCHECK") {
      //After Confirmatin from iFrame Returned message {NEEDTOCHECK or Confirmation}.
      //Here use CheckOrderStatus to check order status.
      //Documentation https://documenter.getpostman.com/view/17550185/2s93XzwN9o
      Navigator.pop(context);
    }
    setState(() {
      title = message.message;
    });
  }

  Future<CreateOrderModel> createOrder(String token) async {
    CreateOrderModel createOrderModel;
    var response = await http.post(
        Uri.parse('https://Url/v1/CashPay/CreateOrder'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': token
        },
        body: jsonEncode(<String, Object>{
          "requestId": Random().nextInt(1000).toString(),
          "currencyID": 2,
          "payementTime": 5,
          "beneficiaryList": beneficiaryList!.map((e) => e.toJson()).toList(),
          // "beneficiaryList": [
          //   {
          //     "identifier": "777777777",
          //     "identifierType": 1,
          //     "amount": 3000,
          //     "itemName": "ماوس"
          //   },
          //   {
          //     "identifier": "777777777",
          //     "identifierType": 1,
          //     "amount": 2000,
          //     "itemName": "ساعة"
          //   }
          // ],
          "des": desc
        }));
    if (response.statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      createOrderModel = CreateOrderModel.fromJson(jsonDecode(response.body));
      if (createOrderModel.ResultCode == 1) {
        return createOrderModel;
      } else {
        return const CreateOrderModel(
            ResultCode: -1, iframeURL: "", orderID: "");
      }
    } else {
      return const CreateOrderModel(ResultCode: -1, iframeURL: "", orderID: "");
    }
  }

  onChackWristwatch(bool value, double amount, String des) {
    check1 = value;
    if (value) {
      setState(() {
        desc += des;
        beneficiaryList!.add(BeneficiaryList(
            amount: amount,
            identifier: "777777777",
            identifierType: 1,
            itemName: des));
      });
      print(
          'onChackWristwatch ${beneficiaryList!.map((e) => e.toJson()).toList()}');
    } else {
      setState(() {
        desc = desc.replaceAll(des, "");
        beneficiaryList!
            .removeWhere((element) => element.identifier == "771345623");
      });
      print(
          'onChackWristwatch ${beneficiaryList!.map((e) => e.toJson()).toList()}');
    }
  }
}

class BeneficiaryList {
  final String identifier;
  final int identifierType;
  final double amount;
  final String itemName;

  const BeneficiaryList(
      {required this.identifier,
      required this.identifierType,
      required this.amount,
      required this.itemName});

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'identifierType': identifierType,
      'amount': amount,
      'itemName': itemName
    };
  }
}

class CreateOrderModel {
  final int ResultCode;
  final String iframeURL;
  final String orderID;

  const CreateOrderModel(
      {required this.ResultCode,
      required this.iframeURL,
      required this.orderID});

  factory CreateOrderModel.fromJson(Map<String, dynamic> json) {
    return CreateOrderModel(
      ResultCode: json['ResultCode'],
      iframeURL: json['iframeURL'],
      orderID: json['orderID'],
    );
  }
}
