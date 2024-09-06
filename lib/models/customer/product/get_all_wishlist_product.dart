class GetAllWishlistProductModel {
  int? productId;
  String? sellerId;
  String? name;
  String? description;
  String? category;
  String? storeName;
  bool? isWishList;
  List<Details>? details;
  List<String>? images;

  GetAllWishlistProductModel(
      {this.productId,
      this.sellerId,
      this.name,
      this.description,
      this.category,
      this.storeName,
      this.isWishList,
      this.details,
      this.images});

  GetAllWishlistProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    sellerId = json['sellerId'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    storeName = json['storeName'];
    isWishList = json['isWishList'];
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
    data['sellerId'] = sellerId;
    data['name'] = name;
    data['description'] = description;
    data['category'] = category;
    data['storeName'] = storeName;
    data['isWishList'] = isWishList;
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
