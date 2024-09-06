class GetProductByIdModel {
  int? productId;
  String? name;
  String? description;
  String? category;
  String? storeName;
  List<ProductDetails>? productDetails;
  List<String>? images;

  GetProductByIdModel(
      {this.productId,
      this.name,
      this.description,
      this.category,
      this.storeName,
      this.productDetails,
      this.images});

  GetProductByIdModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    storeName = json['storeName'];
    if (json['productDetails'] != null) {
      productDetails = <ProductDetails>[];
      json['productDetails'].forEach((v) {
        productDetails!.add(ProductDetails.fromJson(v));
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
    data['storeName'] = storeName;
    if (productDetails != null) {
      data['productDetails'] = productDetails!.map((v) => v.toJson()).toList();
    }
    data['images'] = images;
    return data;
  }
}

class ProductDetails {
  int? id;
  String? type;
  int? size;
  int? price;
  int? salePrice;
  int? quantity;

  ProductDetails(
      {this.id,
      this.type,
      this.size,
      this.price,
      this.salePrice,
      this.quantity});

  ProductDetails.fromJson(Map<String, dynamic> json) {
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
