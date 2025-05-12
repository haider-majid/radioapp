class FacebookPost {
  List<Data>? data;

  FacebookPost({this.data});

  FacebookPost.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class Data {
  String? fullPicture;
  String? message;
  String? id;

  Data({this.fullPicture, this.message, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    fullPicture = json['full_picture'];
    message = json['message'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_picture'] = fullPicture;
    data['message'] = message;
    data['id'] = id;
    return data;
  }
}
