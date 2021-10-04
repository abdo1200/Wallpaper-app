import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaperhupapp/Data/data.dart';
import 'package:wallpaperhupapp/Widgets/widget.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperhupapp/models/wallpaper.dart';

class Search extends StatefulWidget {
  final String SearchQuery;

  const Search(this.SearchQuery);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = new TextEditingController();
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
    getSearchWallpapers(widget.SearchQuery);
    super.initState();
    searchController.text = widget.SearchQuery;
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
                        Wallpapers.clear();
                        getSearchWallpapers(searchController.text);
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
                future: getSearchWallpapers(widget.SearchQuery),
              )
            ],
          ),
        ),
      ),
    );
  }
}
