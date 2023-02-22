import 'package:flutter_traning_app_1/utils/library.dart';
import 'package:webview_cookie_manager/webview_cookie_manager.dart';

import '../main.dart';

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  final cookieManager = WebviewCookieManager();

  /// Get cookies
  void getCookies(String url) async {
    final gotCookies = await cookieManager.getCookies(url);
    for (var item in gotCookies) {
      print(item);
    }
  }

  // /// Set cookies
  // void setCookies(String url) async {
  //   cookieManager.setCookies([
  //     Cookie(cookieName, cookieValue)
  //       ..domain = domain
  //       ..expires = DateTime.now().add(Duration(days: 10))
  //       ..httpOnly = false
  //   ]);
  // }

  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            getCookies(url);
          },
          onPageFinished: (String url) {
            getCookies(url);
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {

            if (request.url.startsWith(url)) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
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
      ..loadRequest(Uri.parse(url));
    controller.canGoBack();

    /// Get cookies
    getCookies(url);

    return Scaffold(
        body:

            /// Webview widget
            WillPopScope(
                onWillPop: () async {
                  controller.goBack();
                  return false;
                },
                child: WebViewWidget(controller: controller)));
  }
}
