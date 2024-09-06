class GetAllCategory {
  bool? success;
  int? statusCode;
  String? errorMessage;
  List<Response>? response;

  GetAllCategory(
      {this.success, this.statusCode, this.errorMessage, this.response});

  GetAllCategory.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    errorMessage = json['errorMessage'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['errorMessage'] = errorMessage;
    if (response != null) {
      data['response'] = response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  int? id;
  String? productCategoryName;
  String? image;

  Response({this.id, this.productCategoryName, this.image});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCategoryName = json['productCategoryName'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['productCategoryName'] = productCategoryName;
    data['image'] = image;
    return data;
  }
}
