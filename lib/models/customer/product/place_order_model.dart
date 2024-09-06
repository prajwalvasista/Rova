class PlaceOrder {
  bool? success;
  int? statusCode;
  String? errorMessage;
  String? response;

  PlaceOrder({this.success, this.statusCode, this.errorMessage, this.response});

  PlaceOrder.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    errorMessage = json['errorMessage'];
    response = json['response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['errorMessage'] = errorMessage;
    data['response'] = response;
    return data;
  }
}
