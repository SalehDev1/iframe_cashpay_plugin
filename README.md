# iframe_cashpay_plugin

iframe_cashpay_plugin.
A plugin to add payments Cash E-wallet to your flutter application.

## Platform Support

| Android |
| :-----: |

## Getting Started

Before you start, create an APIs with the payment providers and follow the setup instructions:
[https://documenter.getpostman.com/view/17550185/2s93XzwN9o](https://documenter.getpostman.com/view/17550185/2s93XzwN9o)

## Usage

To start using this plugin, add `iframe_cashpay_plugin` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/):

```yaml
dependencies:
  iframe_cashpay_plugin: ^2.0.0
```

## Example

````dart
import 'package:iframe_cashpay_plugin/iframe_cashpay_plugin.dart';

class PaySampleAppState extends State<PaySampleApp> {
 String orderId = "";
/// This function Send itemList for yor server.
///
/// @param itemList.
/// @return iframeURL and orderId.
///
/// Example:
///
/// ```
/// var res = sendItems(itemList);
/// print(res.then((iframeURL)=>iframeURL)); // "https://########"
/// ```
  Future<String> sendItems(itemList) async {
    //Send itemList for yor server and post CreateOrder.
    //iframeURL returned from Response CreateOrder
    //Documentation https://documenter.getpostman.com/view/17550185/2s93XzwN9o
    String iframeURL = "https://############################################";
    //orderID returned from Response CreateOrder
    //Store the orderID in the orderId variable to use on function onConfirmPayment
    orderId = "";
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
              style: ElevatedButton.styleFrom(
                primary:
                    const Color.fromARGB(255, 0, 120, 120), // Background color
                textStyle: const TextStyle(color: Colors.white), // Text color
              ),
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
                    isDismissible: false,
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
                          //IframeCashPay widget displays the Cash E-wallet payment iframe.
                         /// This widget IframeCashPay displays the Cash E-wallet payment iframe.
                        ///
                        /// @param iframeURL .
                        /// @param onConfirmPayment.
                        /// @param onCancel.
                        /// @param onError.
                        /// @return message onConfirmPayment or onCancel or onError.
                        ///
                        /// Example:
                        ///
                        /// ```
                        ///  IframeCashPay( iframeURL: "https://########",
                        ///    onConfirmPayment: onConfirmPayment,
                        ///    onCancel: onCancel,
                        ///    onError: onError,);
                        /// ```
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

/// This function callback onConfirmPayment.
///
/// @param message.
/// @return message onConfirmPayment.
///
/// Example:
///
/// ```
/// onConfirmPayment("NEEDTOCHECK");
/// ```
  onConfirmPayment(message) {
    //After Confirmatin from iFrameCashPay.
    if (orderId.isNotEmpty) {
      //Here use CheckOrderStatus on your server to check order status.
      //Documentation https://documenter.getpostman.com/view/17550185/2s93XzwN9o
    }
    Navigator.pop(context);
  }

/// This function callback onCancel.
///
/// @param message.
/// @return message onCancel.
///
/// Example:
///
/// ```
/// onCancel("Cancel");
/// ```
  onCancel(message) {
    //After Cancel from iFrameCashPay.
    Navigator.pop(context);
  }

/// This function callback onError.
///
/// @param message.
/// @return message onError.
///
/// Example:
///
/// ```
/// onError("Error");
/// ```
  onError(message) {
    //After return Error from iFrameCashPay.
    Navigator.pop(context);
  }
}
````

## The following is a brief explanation of each method:

**sendItems():** This method sends the item list to the server and creates an order. The method returns the iframe URL, which is then used to create an IframeCashPay widget.

**IframeCashPay** widget displays the Cash E-wallet payment iframe.

**onConfirmPayment():** This method is called when the user confirms the payment.This method can be used to handle the payment confirmation event.

**onCancel():** This method is called when the user cancels the payment. This method can be used to handle the payment cancellation event.

**onError():** This method is called when an error occurs during the payment process. This method can be used to handle the payment error event.
