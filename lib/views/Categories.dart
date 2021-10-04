import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhupapp/Data/data.dart';
import 'package:wallpaperhupapp/Widgets/widget.dart';
import 'package:wallpaperhupapp/models/wallpaper.dart';

class Categories extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String Category;

  // ignore: non_constant_identifier_names
  const Categories({this.Category});
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  // ignore: non_constant_identifier_names
  List<Wallpaper> Wallpapers = [];

  getSearchWallpapers(String query) async {
    var response = await http.get(
      "https://api.pexels.com/v1/search?query=$query&per_page=15&page1",
      headers: {
        "Authorization": apiKey,
      },
    );
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['photos'].forEach((element) {
      Wallpaper wallpaper = new Wallpaper();
      wallpaper = Wallpaper.forMap(element);
      Wallpapers.add(wallpaper);
    });
  }

  @override
  void initState() {
    getSearchWallpapers(widget.Category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text(widget.Category,style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.indigo,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              FutureBuilder(
                builder: (context, wallpaperSnap) {
                  if (wallpaperSnap.connectionState == ConnectionState.none &&
                      wallpaperSnap.hasData == null) {
                    //print('project snapshot data is: ${projectSnap.data}');
                    return Container();
                  }
                  else{
                    return WallpapersList(Wallpapers, context);
                  }
                },
                future: getSearchWallpapers(widget.Category),
              )
            ],
          ),
        ),
      ),
    );
  }
}
