import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/Model/potohs_model.dart';
import 'package:wallpaper/admob/AdManger.dart';
import 'package:wallpaper/widgets/widght.dart';

class Categorie extends StatefulWidget {
  final String categorieName;
  Categorie({required this.categorieName});

  @override
  State<Categorie> createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  BannerAd? bannerAd;
  bool isLoaded = false;
  void load() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: AdManger.bannerHome,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            isLoaded = true;
            setState(() {});
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
          },
        ),
        request: AdRequest())
      ..load();
  }

  //Admob
  List<photo_Model> photos = [];

  getSearchWallpaper(String Query) async {
    await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=$Query&per_page=30"),
        headers: {
          "Authorization":
              "5VD31HhtG6Co0xezBf5I0LbGiV3QhFPonLOFgtFpxFFxwQW0cAUC6ABp"
        }).then((value) {
      //print(value.body);

      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        //print(element);
        photo_Model photosModel = new photo_Model();
        photosModel = photo_Model.fromMap(element);
        photos.add(photosModel);
        //print(photosModel.toString()+ "  "+ photosModel.src.portrait);
      });

      setState(() {});
    });
  }

  @override
  void initState() {
    getSearchWallpaper(widget.categorieName);
    load();
    super.initState();
  }

  @override
  void dispose() {
    if (isLoaded) {
      bannerAd!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 16,
            ),
            photosList(photos: photos, context: context),
            //Admob
            Center(
                child: isLoaded
                    ? SizedBox(
                        width: bannerAd!.size.width.toDouble(),
                        height: bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: bannerAd!),
                      )
                    : SizedBox()),
          ],
        ),
      ),
    ));
  }
}
