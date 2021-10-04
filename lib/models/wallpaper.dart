class Wallpaper {
  String photographer;
  // ignore: non_constant_identifier_names
  String photographer_url;
  // ignore: non_constant_identifier_names
  int photographer_id;
  SrcModel src;
  Wallpaper({
    this.photographer,
    // ignore: non_constant_identifier_names
    this.photographer_url,
    // ignore: non_constant_identifier_names
    this.photographer_id,
    this.src,
  });

  factory Wallpaper.forMap(Map<String, dynamic> jsonData) {
    return Wallpaper(
        src: SrcModel.forMap(jsonData['src']),
        photographer_url: jsonData['photographer_url'],
        photographer_id: jsonData['photographer_id'],
        photographer: jsonData['photographer']);
  }
}

class SrcModel {
  String original;
  String small;
  String portrait;
  SrcModel({
    this.original,
    this.small,
    this.portrait,
  });

  factory SrcModel.forMap(Map<String, dynamic> jsonData) {
    return SrcModel(
      original: jsonData['original'],
      small: jsonData['small'],
      portrait: jsonData['portrait'],
    );
  }
}
