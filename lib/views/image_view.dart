import 'dart:io';
import 'package:flutter/material.dart';
import 'package:wallpaper/wallpaper.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker_saver/image_picker_saver.dart';

class ImageView extends StatefulWidget {
  final String src;
  const ImageView({this.src});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var _imageFile;
  void _onImageSaveButtonPressed() async {
    print("_onImageSaveButtonPressed");
    var response = await http.get(widget.src);

    debugPrint(response.statusCode.toString());

    var filePath =
        await ImagePickerSaver.saveFile(fileData: response.bodyBytes);

    var savedFile = File.fromUri(Uri.file(filePath));
    setState(() {
      _imageFile = Future<File>.sync(() => savedFile);
    });
    int location = WallpaperManager
        .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
    final String result =
        await WallpaperManager.setWallpaperFromFile(filePath, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Hero(
          tag: widget.src,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.network(
              widget.src,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  _onImageSaveButtonPressed();
                },
                child: Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 53,
                        decoration: BoxDecoration(
                          color: Color(0Xff1C1B1B).withOpacity(1),
                          border: Border.all(color: Colors.white54, width: 1),
                          borderRadius: BorderRadius.circular(30),
                        )),
                    Container(
                      height: 53,
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54, width: 1),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.indigo,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Set Wallpaper",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          SizedBox(height: 3,),
                          Text(
                            "Image will be Saved in gallary",
                            style:
                                TextStyle(fontSize: 10, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30)
                  ),
                  child: Text(
                    "Cancle",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20)
            ],
          ),
        )
      ],
    ));
  }
}
