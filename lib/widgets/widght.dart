import 'package:flutter/material.dart';
import 'package:wallpaper/Model/potohs_model.dart';
import 'package:wallpaper/viwes/image_viwe.dart';

Widget BrandName() {
  return Row(
    children: [
      Text(
        "Wallpaper",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(width: 5),
      Text(
        "Hup",
        style: TextStyle(
          fontSize: 20,
          color: Colors.redAccent,
          fontWeight: FontWeight.bold,
        ),
      )
    ],
  );
}

Widget photosList({required List<photo_Model> photos, context}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        mainAxisSpacing: 6.0,
        crossAxisSpacing: 6.0,
        children: photos.map((photos) {
          return GridTile(
              child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FullScreen(
                            imgUrl: photos.src!.portrait!,
                          )));
            },
            child: Hero(
              tag: photos.src!.portrait!,
              child: Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    photos.src!.portrait!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ));
        }).toList()),
  );
}
