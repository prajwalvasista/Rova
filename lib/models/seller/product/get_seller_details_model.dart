class GetSellerDetailsModel {
  bool? success;
  int? statusCode;
  String? errorMessage;
  List<Response>? response;

  GetSellerDetailsModel(
      {this.success, this.statusCode, this.errorMessage, this.response});

  GetSellerDetailsModel.fromJson(Map<String, dynamic> json) {
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
  String? gsTNumber;
  String? paNNumber;
  String? paNDocument;
  String? storeName;
  String? city;
  int? pincode;
  String? state;
  String? area;
  bool? shippingPreference;
  String? sellerId;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? alternatePhoneNumber;
  bool? enable;
  bool? isApproved;

  Response(
      {this.gsTNumber,
      this.paNNumber,
      this.paNDocument,
      this.storeName,
      this.city,
      this.pincode,
      this.state,
      this.area,
      this.shippingPreference,
      this.sellerId,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.alternatePhoneNumber,
      this.enable,
      this.isApproved});

  Response.fromJson(Map<String, dynamic> json) {
    gsTNumber = json['gsT_Number'];
    paNNumber = json['paN_Number'];
    paNDocument = json['paN_Document'];
    storeName = json['storeName'];
    city = json['city'];
    pincode = json['pincode'];
    state = json['state'];
    area = json['area'];
    shippingPreference = json['shippingPreference'];
    sellerId = json['sellerId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    phoneNumber = json['phoneNumber'];
    alternatePhoneNumber = json['alternatePhoneNumber'];
    enable = json['enable'];
    isApproved = json['isApproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gsT_Number'] = gsTNumber;
    data['paN_Number'] = paNNumber;
    data['paN_Document'] = paNDocument;
    data['storeName'] = storeName;
    data['city'] = city;
    data['pincode'] = pincode;
    data['state'] = state;
    data['area'] = area;
    data['shippingPreference'] = shippingPreference;
    data['sellerId'] = sellerId;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['phoneNumber'] = phoneNumber;
    data['alternatePhoneNumber'] = alternatePhoneNumber;
    data['enable'] = enable;
    data['isApproved'] = isApproved;
    return data;
  }
}
