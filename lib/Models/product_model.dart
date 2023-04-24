
class PostApiModel {
  int? albumId;
  int? id;
  String? title;
  String? url;
  String? thumbnailUrl;

  PostApiModel({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  PostApiModel.fromJson(Map<String, dynamic> json) {
    if(json["albumId"] is int) {
      albumId = json["albumId"];
    }
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["title"] is String) {
      title = json["title"];
    }
    if(json["url"] is String) {
      url = json["url"];
    }
    if(json["thumbnailUrl"] is String) {
      thumbnailUrl = json["thumbnailUrl"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["albumId"] = albumId;
    _data["id"] = id;
    _data["title"] = title;
    _data["url"] = url;
    _data["thumbnailUrl"] = thumbnailUrl;
    return _data;
  }
}