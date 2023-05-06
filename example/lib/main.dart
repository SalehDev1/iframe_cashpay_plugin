import 'package:flutter/material.dart';
import 'package:iframe_cashpay_plugin/iframe_cashpay_plugin.dart';

void main() {
  runApp(const PayMaterialApp());
}

class PayMaterialApp extends StatelessWidget {
  const PayMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pay for Flutter Demo',
      home: PaySampleApp(title: 'PaySampleApp'),
    );
  }
}

class PaySampleApp extends StatefulWidget {
  final String title;
  const PaySampleApp({Key? key, required this.title}) : super(key: key);

  @override
  State<PaySampleApp> createState() => PaySampleAppState();
}

class PaySampleAppState extends State<PaySampleApp> {
  Future<String> sendItems(itemList) async {
    //Send itemList for yor server and post CreateOrder.
    //iframeURL returned from Response CreateOrder
    //Documentation https://documenter.getpostman.com/view/17550185/2s93XzwN9o
    String iframeURL =
        "**********************************************************";
    return iframeURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        backgroundColor: Colors.white,
        body: ListView(children: [
          ElevatedButton(
              child: const Text('الدفع عبر كاش باي'),
              onPressed: () async {
                await sendItems({
                  {
                    "itemName": "كتاب",
                    "amount": 2000,
                  },
                  {
                    "itemName": "ساعة",
                    "amount": 5000,
                  }
                }).then((iframeURL) => showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30.0),
                      ),
                    ),
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Container(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 10.0),
                          height: MediaQuery.of(context).size.height * 0.7,
                          //IframeCashPay SDK to use iFrame CashPay
                          child: IframeCashPay(
                            iframeURL: iframeURL,
                            onConfirmPayment: onConfirmPayment,
                            onCancel: onCancel,
                            onError: onError,
                          ));
                    }));
              }),
        ]));
  }

  //Await for iFrameCashPay
  onConfirmPayment(message) {
    Navigator.pop(context);
    //After Confirmatin from iFrameCashPay.
    //Here use CheckOrderStatus to check order status.
    //Documentation https://documenter.getpostman.com/view/17550185/2s93XzwN9o
  }

//Await for iFrameCashPay
  onCancel(message) {
    //After Cancel from iFrameCashPay.
    Navigator.pop(context);
  }

//Await for iFrameCashPay
  onError(message) {
    //After return Error from iFrameCashPay.
    Navigator.pop(context);
  }
}
