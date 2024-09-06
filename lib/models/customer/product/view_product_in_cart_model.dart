class ViewProductInCartModel {
  int? productId;
  String? customerId;
  List<String>? images;
  String? name;
  int? size;
  int? price;
  int? salePrice;
  int? quantity;

  ViewProductInCartModel(
      {this.productId,
      this.customerId,
      this.images,
      this.name,
      this.size,
      this.price,
      this.salePrice,
      this.quantity});

  ViewProductInCartModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    customerId = json['customerId'];
    images = json['images'].cast<String>();
    name = json['name'];
    size = json['size'];
    price = json['price'];
    salePrice = json['sale_Price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['productId'] = productId;
    data['customerId'] = customerId;
    data['images'] = images;
    data['name'] = name;
    data['size'] = size;
    data['price'] = price;
    data['sale_Price'] = salePrice;
    data['quantity'] = quantity;
    return data;
  }
}
