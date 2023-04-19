# iframe_cashpay_plugin

iframe_cashpay_plugin.
A plugin to add payments iframe_cashpay to your Flutter application.

## Platform Support

| Android
|:---:|:---:|

## Getting Started

Before you start, create an APIs with the payment providers you are planning to support and follow the setup instructions:
https://documenter.getpostman.com/view/17550185/2s93XzwN9o

## Usage

To start using this plugin, add `iframe_cashpay_plugin` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/):

```yaml
dependencies:
  pay: ^0.0.3
```

### Example

```dart
import 'package:iframe_cashpay_plugin/iframe_cashpay_plugin.dart';

List<BeneficiaryList>? beneficiaryList = [];
  String? title = "PaySampleApp";
  bool? check1 = false;
  String desc = "";
  //Token returned from Response login
  //Documentation https://documenter.getpostman.com/view/17550185/2s93XzwN9o
  String token ="";

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
                //Here use CreateOrder Api
                //Documentation https://documenter.getpostman.com/view/17550185/2s93XzwN9o
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
                                      //iFrameCashPay SDK to use iFrame CashPay
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

```
