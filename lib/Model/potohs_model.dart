class photo_Model {
  String? url;
  srcModel? src;

  photo_Model({this.url, this.src});
  factory photo_Model.fromMap(Map<String, dynamic> parsedjson) {
    return photo_Model(
        url: parsedjson["url"], src: srcModel.fromMap(parsedjson["src"]));
  }
}

class srcModel {
  String? portrait;
  String? large;
  String? medium;
  String? landscape;

  srcModel({this.portrait, this.landscape, this.large, this.medium});
  factory srcModel.fromMap(Map<String, dynamic> srcjson) {
    return srcModel(
      portrait: srcjson["portrait"],
      large: srcjson["Large"],
      landscape: srcjson["landscape"],
      medium: srcjson["medium"],
    );
  }
}
