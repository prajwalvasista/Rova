class OrderListModel {
  String? orderId;
  int? productId;
  String? customerId;
  String? name;
  String? description;
  String? category;
  String? sellerId;
  String? storeName;
  bool? isWishList;
  String? orderDecision;
  List<Details>? details;
  List<String>? images;

  OrderListModel(
      {this.orderId,
      this.productId,
      this.customerId,
      this.name,
      this.description,
      this.category,
      this.sellerId,
      this.storeName,
      this.isWishList,
      this.orderDecision,
      this.details,
      this.images});

  OrderListModel.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    productId = json['productId'];
    customerId = json['customerId'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    sellerId = json['sellerId'];
    storeName = json['storeName'];
    isWishList = json['isWishList'];
    orderDecision = json['orderDecision'];
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
    data['orderId'] = orderId;
    data['productId'] = productId;
    data['customerId'] = customerId;
    data['name'] = name;
    data['description'] = description;
    data['category'] = category;
    data['sellerId'] = sellerId;
    data['storeName'] = storeName;
    data['isWishList'] = isWishList;
    data['orderDecision'] = orderDecision;
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
