class GetOrderProductsCountModel {
  String? status;
  int? productsCount;

  GetOrderProductsCountModel({this.status, this.productsCount});

  GetOrderProductsCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    productsCount = json['productsCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['productsCount'] = productsCount;
    return data;
  }
}
