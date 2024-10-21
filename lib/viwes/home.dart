import 'dart:convert';
import 'dart:core';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/Model/Categories_model.dart';
import 'package:wallpaper/Model/potohs_model.dart';
import 'package:wallpaper/admob/AdManger.dart';
import 'package:wallpaper/data/data.dart';
import 'package:wallpaper/viwes/categories.dart';
import 'package:wallpaper/viwes/search.dart';
import 'package:wallpaper/widgets/widght.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
  TextEditingController SearchController = TextEditingController();
  List<photo_Model> photos = [];
  List<CategorieModel> categories = [];

  getTrendingWallpaper() async => await http.get(
          Uri.parse("https://api.pexels.com/v1//curated?per_page=&page=1"),
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

  @override
  void initState() {
    getTrendingWallpaper();
    categories = getCategories();
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
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 231, 81, 81),
          elevation: 1,
          title: Text(
            "Heom",
            style: TextStyle(color: Colors.black),
          )),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(20)),
                padding: EdgeInsets.symmetric(horizontal: 16),
                margin: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: SearchController,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: "Search"),
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => search(
                                      SearchQuery: SearchController.text)));
                        },
                        child: Container(child: Icon(Icons.search))),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              //categories
              Container(
                height: 80,
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return categoriesTile(
                      title: categories[index].categorieName,
                      imgUrl: categories[index].imgUrl,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 5,
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
      ),
    );
  }
}

//
class categoriesTile extends StatelessWidget {
  final String imgUrl, title;

  const categoriesTile({required this.imgUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Categorie(categorieName: title.toLowerCase())));
      },
      child: Container(
          margin: EdgeInsets.only(right: 4),
          child: Stack(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                height: 50,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              height: 50,
              width: 100,
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ])),
    );
  }
}
