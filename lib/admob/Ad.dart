import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaper/admob/AdManger.dart';

class Ads {
  InterstitialAd? _interstitialAd;

  void showAd() {
    InterstitialAd.load(
        adUnitId: AdManger.Interstitial,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            if (_interstitialAd != null) {
              _interstitialAd!.show();
            }
            ad.fullScreenContentCallback =
                FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
            }, onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
            });
          },
          onAdFailedToLoad: (error) {
            print("error");
          },
        ));
  }
}
