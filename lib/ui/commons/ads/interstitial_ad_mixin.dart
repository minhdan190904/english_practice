import 'dart:io';
import 'package:amplitude_flutter/amplitude.dart';
import 'package:amplitude_flutter/events/base_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../configs/di.dart';
import '../../../utils/ad/consent_manager.dart';

mixin InterstitialAdMixin<T extends StatefulWidget> on State<T> {
  InterstitialAd? _interstitialAd;

  final _adUnitId =
      Platform.isAndroid
          ? const String.fromEnvironment('ANDROID_INTERSTITIAL_AD_UNIT_ID')
          : const String.fromEnvironment('IOS_INTERSTITIAL_AD_UNIT_ID');

  final _amplitude = DI().sl<Amplitude>();

  @override
  void initState() {
    super.initState();
    ConsentManager.gatherConsent((consentError) {
      if (consentError != null) {
        debugPrint("Consent error: ${consentError.errorCode}: ${consentError.message}");
        _interstitialAd?.dispose();
        _loadInterstitialAd();
      }
    });
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() async {
    if (!await ConsentManager.canRequestAds() || !mounted || isPremium) {
      return;
    }
    debugPrint('Loading InterstitialAd');
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          debugPrint('InterstitialAd loaded');
          setState(() {
            _interstitialAd = ad;
          });

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _amplitude.track(BaseEvent("interstitial_ad_failed_to_load"));
          FirebaseAnalytics.instance.logEvent(name: 'interstitial_ad_failed_to_load', parameters: {'error': error.toString()});
          debugPrint('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (isPremium) return;
    if (_interstitialAd != null) {
      _interstitialAd!.show();
      _amplitude.track(BaseEvent("interstitial_ad_impression"));
      _interstitialAd = null;
    } else {
      debugPrint('InterstitialAd is not ready yet.');
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  bool get isPremium;
}
