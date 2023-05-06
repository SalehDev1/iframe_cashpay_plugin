import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';

// const kAndroidUserAgent =
//     'Mozilla/5.0 (Linux; Android 10.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class IframeCashPay extends StatefulWidget {
  final String iframeURL;
  final JavascriptMessageHandler onConfirmPayment;
  final JavascriptMessageHandler onCancel;
  final JavascriptMessageHandler onError;
  const IframeCashPay(
      {Key? key,
      required this.iframeURL,
      required this.onConfirmPayment,
      required this.onCancel,
      required this.onError})
      : super(key: key);

  @override
  State<IframeCashPay> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<IframeCashPay> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  // On destroy stream
  late StreamSubscription _onDestroy;

  // On urlChanged stream
  late StreamSubscription<String> _onUrlChanged;

  // On urlChanged stream
  late StreamSubscription<WebViewStateChanged> _onStateChanged;

  late StreamSubscription<WebViewHttpError> _onHttpError;

  late StreamSubscription<double> _onProgressChanged;

  late StreamSubscription<double> _onScrollYChanged;

  late StreamSubscription<double> _onScrollXChanged;

  final _history = [];

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();

    // Add a listener to on destroy WebView, so you can make came actions.
    _onDestroy = flutterWebViewPlugin.onDestroy.listen((_) {
      if (mounted) {
        // Actions like show a info toast.
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Webview Destroyed')));
      }
    });

    // Add a listener to on url changed
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        setState(() {
          _history.add('onUrlChanged: $url');
        });
      }
    });

    _onProgressChanged =
        flutterWebViewPlugin.onProgressChanged.listen((double progress) {
      if (mounted) {
        setState(() {
          _history.add('onProgressChanged: $progress');
        });
      }
    });

    _onScrollYChanged =
        flutterWebViewPlugin.onScrollYChanged.listen((double y) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in Y Direction: $y');
        });
      }
    });

    _onScrollXChanged =
        flutterWebViewPlugin.onScrollXChanged.listen((double x) {
      if (mounted) {
        setState(() {
          _history.add('Scroll in X Direction: $x');
        });
      }
    });

    _onStateChanged =
        flutterWebViewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      if (mounted) {
        setState(() {
          _history.add('onStateChanged: ${state.type} ${state.url}');
        });
      }
    });

    _onHttpError =
        flutterWebViewPlugin.onHttpError.listen((WebViewHttpError error) {
      if (mounted) {
        setState(() {
          _history.add('onHttpError: ${error.code} ${error.url}');
        });
      }
    });
  }

  onMessage(JavascriptMessage message) {
    if (message.message == "Confirmation" || message.message == "NEEDTOCHECK") {
      widget.onConfirmPayment(message);
    } else if (message.message == "Cancel") {
      widget.onCancel(message);
    } else if (message.message == "Error") {
      widget.onError(message);
    }
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    _onDestroy.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    _onProgressChanged.cancel();
    _onScrollXChanged.cancel();
    _onScrollYChanged.cancel();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebviewScaffold(
        url: widget.iframeURL,
        ignoreSSLErrors: true,
        javascriptChannels: {
          JavascriptChannel(name: 'flutter', onMessageReceived: onMessage)
        },
        withLocalStorage: true,
        appCacheEnabled: false,
        resizeToAvoidBottomInset: true,
        initialChild: Container(
          color: Colors.white,
          child: const Center(
            child: Text('Waiting.....'),
          ),
        ),
      ),
    );
  }
}
