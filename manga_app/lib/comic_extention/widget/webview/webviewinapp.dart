import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../loading.dart';

class WebViewInApp extends StatefulWidget {
  final String data;
  final String category;
  final Function(InAppWebViewController controller) onLoad;
  final Function(InAppWebViewController controller) onLoadSuccess;
  final Function(String error) onLoadFail;
  final Function(Map<String, dynamic> event)? onEvent;
  WebViewInApp({Key? key, this.category = 'ReadComics', required this.data, required this.onLoad, required this.onLoadSuccess, required this.onLoadFail, this.onEvent}) : super(key: key);

  @override
  State<WebViewInApp> createState() => _WebViewInAppState();
}

class _WebViewInAppState extends State<WebViewInApp> with WidgetsBindingObserver {
  InAppWebViewController? _webViewController;

  PullToRefreshController? pullToRefreshController;

  bool pullToRefreshEnabled = true;

  var isLoading = true;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    print(dataWebView(data: widget.data));
    // TODO: implement initState
    super.initState();
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
      settings: PullToRefreshSettings(
          color: Colors.blue
      ),
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          widget.onEvent!({
            'reload': ""
          });
        } else if (defaultTargetPlatform == TargetPlatform.iOS) {
          widget.onEvent!({
            'reload': ""
          });
        }
      },
    );
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_webViewController != null) {
      switch (state) {
        case AppLifecycleState.resumed:
          _webViewController!.resume();
          break;
        case AppLifecycleState.inactive:
        case AppLifecycleState.paused:
          _webViewController!.pause();
          break;
        case AppLifecycleState.detached:
          WidgetsBinding.instance.removeObserver(this);
          break;
        case AppLifecycleState.hidden:
          break;
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print('close webview');
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {

    /* version inappwebview 5.x.x
    InAppWebViewGroupOptions initialOptions = InAppWebViewGroupOptions();

    initialOptions.crossPlatform.useOnDownloadStart = true;
    initialOptions.crossPlatform.useOnLoadResource = true;
    initialOptions.crossPlatform.useShouldOverrideUrlLoading = true;
    initialOptions.crossPlatform.javaScriptCanOpenWindowsAutomatically = true;
    initialOptions.crossPlatform.transparentBackground = true;

    // initialOptions.ios.allowsLinkPreview = true;
    // initialOptions.ios.isFraudulentWebsiteWarningEnabled = true;
    // initialOptions.ios.disableLongPressContextMenuOnLinks = true;
    // initialOptions.ios.allowsInlineMediaPlayback = true;
    */
    InAppWebViewSettings initialSetting = InAppWebViewSettings();
    initialSetting.useOnDownloadStart = true;
    initialSetting.useOnLoadResource = true;
    initialSetting.useShouldOverrideUrlLoading = true;
    initialSetting.javaScriptCanOpenWindowsAutomatically = true;
    initialSetting.transparentBackground = true;
    initialSetting.useHybridComposition = false;
    return Stack(
      children: [
        InAppWebView(
          gestureRecognizers: Set()..add(Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())),
          initialData: InAppWebViewInitialData(data: dataWebView(data: widget.data)),
          // initialOptions: initialOptions,
          initialSettings: initialSetting,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) async {
            _webViewController = controller;
          },
          onLoadStart: (controller, url) async {
            print('Page started loading: $url');
            widget.onLoad(controller);
          },
          onLoadStop: (controller, url) async {
            print('Page finished loading: $url');
            widget.onLoadSuccess(controller);
            pullToRefreshController?.endRefreshing();
            setState(() {
              isLoading = false;
            });
          },
          onConsoleMessage: (controller,mess) async {
            try{
              final dynamic object = json.decode(mess.message);
              String status = object['status'];
              // print('console: $object');
              switch(status){
                case "scroll": {
                  widget.onEvent!({
                    'scroll': {
                      'e': object['scroll'],
                      'position': object['lastScrollTop']
                    }
                  });
                } break;
                case "click": {
                  widget.onEvent!({
                    'click': {
                      'e': object['click'],
                      'isclick' : object['isclick']
                    }
                  });
                } break;
              }
            }catch(e){
              widget.onLoadFail(e.toString());
            }
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url;
            if (navigationAction.isForMainFrame &&
                url != null &&
                ![
                  // 'http',
                  // 'https',
                  'file',
                  'chrome',
                  'data',
                  'javascript',
                  'about'
                ].contains(url.scheme)) {
              if (await canLaunchUrl(url)) {
                launchUrlString(
                  url.toString(),
                  mode: LaunchMode.externalApplication,
                );
                return NavigationActionPolicy.CANCEL;
              }
            }
            return NavigationActionPolicy.ALLOW;
          },
          onLoadResource: (controller, resource) async {
            var uri = resource.url.toString();
            final resourceType = resource.initiatorType ?? '';
          },
          onProgressChanged: (controller, progress) {
            print('progress: $progress');
            if (progress == 100) {
              pullToRefreshController?.endRefreshing();
            }
          },
        ),
        if (isLoading)
          Container(
            color: Colors.black26,
            child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoadingWidget(),
                    SizedBox(height:5),
                    JumpingText('Loading...',style: TextStyle(color: Colors.white,fontSize: 14),)
                  ],
                )
            ),
          )
      ],
    );
  }
}
String dataWebView({ required String data }) {
  final template = r'''
    <!doctype html>
    <html>
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
      </head>
      <body>
        <style>
          img {
            background-color: #ccc;
            background-image: linear-gradient(0.25turn, #ccc, rgba(255, 255, 255, 0.8), #ccc);
            background-repeat: no-repeat;
            background-size: 100% 100%;
            background-position: -300px 0;
            animation: loading 1s infinite alternate;
          }
          @keyframes loading {  
            to {
              background-position: 300px 0;
            }
          }
        </style>''' +
      data +
      r''' <script>
          var lastScrollTop = 0;
          document.addEventListener("scroll",() =>{ 
             var st = window.pageYOffset || document.documentElement.scrollTop; // Credits: "https://github.com/qeremy/so/blob/master/so.dom.js#L426"
             let scroll = '';
             if (st > lastScrollTop) {
                scroll = 'downscroll';
             } else if (st < lastScrollTop) {
                scroll = 'upscroll';
             }
             lastScrollTop = st <= 0 ? 0 : st; 
             console.log(JSON.stringify({'status': 'scroll', 'scroll': scroll, 'lastScrollTop': lastScrollTop}));
          }, false);
          let isclick = false;
          document.addEventListener("click",() =>{
             isclick = !isclick;
             console.log(JSON.stringify({'status': 'click', 'click': 'true', 'isclick' : isclick}));
          }, false);
        </script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
      </body>
    </html>
    ''';

  return template;
}
