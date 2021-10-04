import 'package:flutter/material.dart';
import 'package:wallpaperhupapp/models/wallpaper.dart';
import 'package:wallpaperhupapp/views/image_view.dart';

Widget BrandName() {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Wallpaper ", style: TextStyle(color: Colors.white)),
        Container(
          padding: EdgeInsets.only(left: 5,right: 5,bottom: 5,top: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text("app", style: TextStyle(color: Colors.indigo))
        ),
      ],
    ),
  );
}

Widget WallpapersList(List<Wallpaper> wallpapers, context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpaper) {
        return GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ImageView(
                            src: wallpaper.src.portrait,
                          )));
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  wallpaper.src.portrait,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}
