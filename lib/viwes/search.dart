import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper/Model/potohs_model.dart';
import 'package:wallpaper/widgets/widght.dart';

class search extends StatefulWidget {
  final String SearchQuery;
  search({required this.SearchQuery});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  List<photo_Model> photos = [];
  TextEditingController SearchController = TextEditingController();

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
    getSearchWallpaper(widget.SearchQuery);
    super.initState();
    SearchController.text = widget.SearchQuery;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              //
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
                          getSearchWallpaper(SearchController.text);
                        },
                        child: Container(child: Icon(Icons.search))),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              photosList(photos: photos, context: context)
            ],
          ),
        ),
      ),
    );
  }
}
