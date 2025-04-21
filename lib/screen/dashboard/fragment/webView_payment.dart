import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewScreen extends StatefulWidget {
  final String url;
  final Function(String invoiceId) saveTransaction;

  PaymentWebViewScreen({required this.url, required this.saveTransaction});

  @override
  _PaymentWebViewScreenState createState() => _PaymentWebViewScreenState();
}

class _PaymentWebViewScreenState extends State<PaymentWebViewScreen> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // Initialize WebViewController
    print('webview');
    late final PlatformWebViewControllerCreationParams params;
    // if (WebViewPlatform.instance is WebKitWebViewPlatform) {
    //   params = WebKitWebViewControllerCreationParams(
    //     allowsInlineMediaPlayback: true,
    //     mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
    //   );
    // } else {
      params = const PlatformWebViewControllerCreationParams();
    // }

    final WebViewController controller =
    WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            final newUrl = change.url;
            debugPrint('url changed to $newUrl');

            if (newUrl != null && newUrl.contains('https://dev.fawaterk.com/success')) {
              final uri = Uri.parse(newUrl);
              final invoiceId = uri.queryParameters['invoice_id'];
              debugPrint('✅ Invoice ID from UrlChange: $invoiceId');
              // ممكن تستخدمه هنا كمان
              widget.saveTransaction(invoiceId!);

            }else if(newUrl != null && newUrl.contains('https://dev.fawaterk.com/fail')){
              toast('payment failed');
              Navigator.pop(context);
            }
          },
          onHttpAuthRequest: (HttpAuthRequest request) {
            // openDialog(request);
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url));

    // // setBackgroundColor is not currently supported on macOS.
    // if (kIsWeb || !Platform.isMacOS) {
    //   controller.setBackgroundColor(const Color(0x80000000));
    // }
    //
    // // #docregion platform_features
    // if (controller.platform is AndroidWebViewController) {
    //   AndroidWebViewController.enableDebugging(true);
    //   (controller.platform as AndroidWebViewController)
    //       .setMediaPlaybackRequiresUserGesture(false);
    // }
    // #enddocregion platform_features

    _webViewController = controller; // Ensures WebView works on Android
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
      ),
      body: WebViewWidget(
        controller: _webViewController,
        // initialUrl: widget.url, // URL from the response
        // javascriptMode: JavascriptMode.unrestricted, // Allow JavaScript for the page
        // onWebViewCreated: (WebViewController webViewController) {
        //   _webViewController = webViewController;
        // },
        // navigationDelegate: (NavigationRequest request) {
        //   // Handle navigation if needed (e.g., for payment completion)
        //   if (request.url.startsWith("your_success_url")) {
        //     // You can check for a success URL here and navigate to another screen
        //     Navigator.pop(context);
        //   }
        //   return NavigationDecision.navigate;
        // },
      ),
    );
  }
}