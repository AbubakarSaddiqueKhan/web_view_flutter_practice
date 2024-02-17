// The web view is used to display the web page i your flutter app .

// To use the web view you must have to add the dependencies of the below package in your app .
// flutter pub add webview_flutter

// To use the webview_flutter plugin on Android you need to set the minSDK to 20. Modify your android/app/build.gradle file as follows:

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewMainPage extends StatefulWidget {
  const WebViewMainPage({super.key});

  @override
  State<WebViewMainPage> createState() => _WebViewMainPageState();
}

class _WebViewMainPageState extends State<WebViewMainPage> {
  late final WebViewController webViewController;
  int loadingPercentage = 0;

  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      // The set navigation delegate method is used to sets the [NavigationDelegate] containing the callback methods that are called during navigation events.
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          print("On page started url : $url");
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          print("Page progress : $progress");
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          print("On Page finished Url : $url");
          setState(() {
            loadingPercentage = 100;
          });
        },
        onNavigationRequest: (navigationRequest) {
          // WebView provides your app with a NavigationDelegate, which enables your app to track and control the page navigation of the WebView widget. When a navigation is initiated by the WebView, for example when a user clicks on a link, the NavigationDelegate is called. The NavigationDelegate callback can be used to control whether the WebView proceeds with the navigation.
          final String host = Uri.parse(navigationRequest.url).host;
          //  This code is used to prevent the user to navigate to the youtube .
          if (host.contains("youtube.com")) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Navigation to $host is blocked")));
            // The navigation decision is the enum in which we have to call it's constant value of the name prevent which is used to Prevent the navigation from taking place.

            return NavigationDecision.prevent;
          } else {
            // Allow the navigation to take place.

            return NavigationDecision.navigate;
          }
        },
      ))

      // The load request method of the web view flutter is used to makes a specific HTTP request and loads the response in the webview.
      ..loadRequest(
        // Makes a specific HTTP request and loads the response in the webview.

        Uri.parse('https://medium.com/@abubakarsaddqiuekhan'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                if (await webViewController.canGoBack()) {
                  await webViewController.goBack();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No Back History Found")));
                }
              },
              icon: const Icon(Icons.arrow_back)),
          IconButton(
              onPressed: () async {
                if (await webViewController.canGoForward()) {
                  await webViewController.goForward();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("No Forward History Fund")));
                }
              },
              icon: const Icon(Icons.arrow_forward)),
          IconButton(
              onPressed: () {
                webViewController.reload();
              },
              icon: const Icon(Icons.refresh_rounded))
        ],
      ),
      // The web view widget is used to display the web page in your flutter app .
      // body: WebViewWidget(
      //   // The only required property of the web view is controller .
      //   controller: webViewController,
      //   // Now first we have to make a controller for that web page .
      // ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: webViewController,
          ),
          if (loadingPercentage < 100)
            Center(
              child: CircularProgressIndicator(
                // The circular progress indicator is used to display the circular progress in the center of the screen with the value of the loading of page progress .
                value: loadingPercentage / 100.0,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await webViewController.loadRequest(
              Uri.parse('https://github.com/AbubakarSaddiqueKhan'));
        },
        child: const Icon(Icons.golf_course),
      ),
    );
  }
}
