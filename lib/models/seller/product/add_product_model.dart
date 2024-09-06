class AddProductModel {
  String? status;
  String? message;
  Data? data;

  AddProductModel({this.status, this.message, this.data});

  AddProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? productId;
  String? name;
  String? description;
  String? category;
  List<Details>? details;
  List<String>? images;

  Data(
      {this.productId,
      this.name,
      this.description,
      this.category,
      this.details,
      this.images});

  Data.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['name'] = name;
    data['description'] = description;
    data['category'] = category;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    data['images'] = images;
    return data;
  }
}

class Details {
  int? id;
  String? type;
  int? size;
  int? price;
  int? salePrice;
  int? quantity;

  Details(
      {this.id,
      this.type,
      this.size,
      this.price,
      this.salePrice,
      this.quantity});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    size = json['size'];
    price = json['price'];
    salePrice = json['sale_Price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['size'] = size;
    data['price'] = price;
    data['sale_Price'] = salePrice;
    data['quantity'] = quantity;
    return data;
  }
}
