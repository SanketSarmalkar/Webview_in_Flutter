import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewStack extends StatefulWidget {
  // const WebViewStack({super.key});
  const WebViewStack({required this.controller, super.key}); // MODIFY

  final WebViewController controller;

  @override
  State<WebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<WebViewStack> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  // @override
  // void initState() {
  //   super.initState();
  //   controller = WebViewController()
  //     ..setNavigationDelegate(NavigationDelegate(
  //       onPageStarted: (url) {
  //         setState(() {
  //           loadingPercentage = 0;
  //         });
  //       },
  //       onProgress: (progress) {
  //         setState(() {
  //           loadingPercentage = progress;
  //         });
  //       },
  //       onPageFinished: (url) {
  //         setState(() {
  //           loadingPercentage = 100;
  //         });
  //       },
  //     ))
  //     ..loadRequest(
  //       Uri.parse('https://flutter.dev'),
  //     );
  // }
  @override
  void initState() {
    super.initState();
    widget.controller
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onNavigationRequest: (navigation) {
            final host = Uri.parse(navigation.url).host;
            if (host.contains('youtube.com')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Blocked $host'),
                ),
              );
              return NavigationDecision.prevent; // blocks the navigation
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'SnackBar',
        onMessageReceived: (message) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(message.message)));
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          //controller: controller,
          controller: widget.controller, // MODIFY
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
