import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaperhupapp/Data/data.dart';
import 'package:wallpaperhupapp/Widgets/widget.dart';
import 'package:wallpaperhupapp/models/Category.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhupapp/models/wallpaper.dart';
import 'package:wallpaperhupapp/views/Categories.dart';

import 'package:wallpaperhupapp/views/search.dart';

import 'image_view.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategorieModel> Categories = [];
  List<Wallpaper> Wallpapers = [];
  TextEditingController searchController = new TextEditingController();

  getTrendingWallpapers() async {
    var response = await http.get(
      "https://api.pexels.com/v1/curated?per_page=15&page1",
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
  void initState(){
    getTrendingWallpapers();
    Categories = getCategoris();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white10,
        appBar: AppBar(
          title: BrandName(),
          backgroundColor: Colors.indigo,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xfff5f8fd),
                      borderRadius: BorderRadius.circular(30)),
                  margin: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                  padding: EdgeInsets.only(left: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                              hintText: "Search Wallpaper",
                              border: InputBorder.none),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Search(searchController.text)));
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Icon(Icons.search,color: Colors.white,)
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: Categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return CategoryTile(Categories[index].imgUrl,
                          Categories[index].categorieName);
                    },
                  ),
                ),
                //WallpapersList(Wallpapers, context),
                FutureBuilder(
                  builder: (context, wallpaperSnap) {
                    if (wallpaperSnap.connectionState == ConnectionState.none &&
                        wallpaperSnap.hasData == null) {
                      return Center(
                        child: SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                      );
                    }
                    else{
                      return WallpapersList(Wallpapers, context);
                    }
                  },
                  future: getTrendingWallpapers(),
                )
              ],
            ),
          ),
        ));
  }
}

class CategoryTile extends StatelessWidget {
  final String imgUrl, title;

  const CategoryTile(this.imgUrl, this.title);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categories(
                      Category: title.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.indigo,width: 3,style: BorderStyle.solid)),
                // borderRadius: BorderRadius.only(
                //   bottomLeft: const Radius.circular(8),
                //   bottomRight: const Radius.circular(8),
                // ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(8),
                  topRight: const Radius.circular(8),
                ),
                child: Image.network(imgUrl,
                    height: 50, width: 100, fit: BoxFit.cover),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black26,
                ),
                alignment: Alignment.center,
                height: 50,
                width: 100,
                child: Text(title,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )))
          ],
        ),
      ),
    );
  }
}
