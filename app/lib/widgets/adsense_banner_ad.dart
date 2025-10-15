import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdSenseBannerAd extends StatefulWidget {
  final String adSlot; // AdSense 광고 슬롯 ID
  final String publisherId; // AdSense 퍼블리셔 ID

  const AdSenseBannerAd({
    super.key,
    required this.adSlot,
    required this.publisherId,
  });

  @override
  State<AdSenseBannerAd> createState() => _AdSenseBannerAdState();
}

class _AdSenseBannerAdState extends State<AdSenseBannerAd> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeAd();
  }

  void _initializeAd() {
    // AdSense 광고 HTML 생성
    final adHtml = '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        body {
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 50px;
            background-color: #ffffff;
        }
        .ad-container {
            width: 100%;
            max-width: 320px;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="ad-container">
        <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=${widget.publisherId}"
                crossorigin="anonymous"></script>
        <!-- 앵커 광고 -->
        <ins class="adsbygoogle"
             style="display:block"
             data-ad-client="${widget.publisherId}"
             data-ad-slot="${widget.adSlot}"
             data-ad-format="auto"
             data-full-width-responsive="true"></ins>
        <script>
             (adsbygoogle = window.adsbygoogle || []).push({});
        </script>
    </div>
</body>
</html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            print('AdSense load error: ${error.description}');
          },
        ),
      )
      ..loadHtmlString(adHtml);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // 높이를 60으로 증가
      color: Colors.grey[100], // 배경색을 회색으로 설정하여 영역 확인
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '광고 로딩 중...',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
