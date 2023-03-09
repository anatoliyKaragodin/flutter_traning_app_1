import 'package:flutter_traning_app_1/utils/library.dart';

import '../main.dart';

class HomePageWeb extends StatefulWidget {
  const HomePageWeb({Key? key}) : super(key: key);

  @override
  State<HomePageWeb> createState() => _HomePageWebState();
}

class _HomePageWebState extends State<HomePageWeb> {
  @override
  Widget build(BuildContext context) {
    CookieManager cookieManager = CookieManager.instance();
    InAppWebViewController? webViewController;
    InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          userAgent: userAgent,
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
        ),
        android: AndroidInAppWebViewOptions(thirdPartyCookiesEnabled: true));
    Uri uri = Uri.parse(url);

    return Scaffold(
        body:

            /// Webview widget
            WillPopScope(
                onWillPop: () async {
                  webViewController?.goBack();
                  return false;
                },
                child: InAppWebView(
                  onWebViewCreated: (controller) async {
                    final prefs = await SharedPreferences.getInstance();
                    var cookiesNames = prefs.getKeys();
                    for (var element in cookiesNames) {
                      var cookieValue = prefs.getString(element);
                      cookieManager.setCookie(
                          url: uri, name: element, value: cookieValue!);
                      webViewController = controller;
                    }
                  },
                  initialOptions: options,
                  onLoadStart:
                      (InAppWebViewController controller, Uri? url) async {
                    // final prefs = await SharedPreferences.getInstance();
                    // var cookiesNames = prefs.getKeys();
                    // for (var element in cookiesNames) {
                    //   var cookieValue = prefs.getString(element);
                    //   cookieManager.setCookie(
                    //       url: url!, name: element, value: cookieValue!);
                    // }
                  },
                  onLoadStop:
                      (InAppWebViewController controller, Uri? url) async {
                    final prefs = await SharedPreferences.getInstance();
                    List<Cookie> cookies =
                        await cookieManager.getCookies(url: url!);
                    cookies.forEach((cookie) async {
                      print(cookie.name + " " + cookie.value);
                      await prefs.setString(cookie.name, cookie.value);
                    });
                  },
                  initialUrlRequest: URLRequest(url: uri),
                )));
  }
}
