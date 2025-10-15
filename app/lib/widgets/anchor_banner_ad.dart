import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class AnchorBannerAd extends StatefulWidget {
  const AnchorBannerAd({super.key});

  @override
  State<AnchorBannerAd> createState() => _AnchorBannerAdState();
}

class _AnchorBannerAdState extends State<AnchorBannerAd> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    try {
      _bannerAd = AdService.createBannerAd();
      _bannerAd!.load().then((_) {
        if (mounted) {
          setState(() {
            _isAdLoaded = true;
          });
        }
      }).catchError((error) {
        print('Failed to load banner ad: $error');
        if (mounted) {
          setState(() {
            _isAdLoaded = false;
          });
        }
      });
    } catch (e) {
      print('Error creating banner ad: $e');
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 광고가 없어도 공간은 확보
    return Container(
      height: 50,
      color: Colors.grey[100],
      child: _isAdLoaded && _bannerAd != null
          ? AdWidget(ad: _bannerAd!)
          : Center(
              child: Text(
                '광고 영역',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ),
    );
  }
}
