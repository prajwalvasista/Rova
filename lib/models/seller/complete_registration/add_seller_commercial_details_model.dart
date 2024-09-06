class AddSellerCommercialDetailsModel {
  String? status;
  String? message;
  Data? data;

  AddSellerCommercialDetailsModel({this.status, this.message, this.data});

  AddSellerCommercialDetailsModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? gsTNumber;
  String? paNNumber;
  String? paNDocument;
  String? storeName;
  String? city;
  int? pincode;
  String? state;
  String? area;
  bool? isGstNo;
  bool? isShippingPrefs;

  Data(
      {this.id,
      this.gsTNumber,
      this.paNNumber,
      this.paNDocument,
      this.storeName,
      this.city,
      this.pincode,
      this.state,
      this.area,
      this.isGstNo,
      this.isShippingPrefs});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    gsTNumber = json['gsT_Number'];
    paNNumber = json['paN_Number'];
    paNDocument = json['paN_Document'];
    storeName = json['storeName'];
    city = json['city'];
    pincode = json['pincode'];
    state = json['state'];
    area = json['area'];
    isGstNo = json['isGstNo'];
    isShippingPrefs = json['isShippingPrefs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['gsT_Number'] = gsTNumber;
    data['paN_Number'] = paNNumber;
    data['paN_Document'] = paNDocument;
    data['storeName'] = storeName;
    data['city'] = city;
    data['pincode'] = pincode;
    data['state'] = state;
    data['area'] = area;
    data['isGstNo'] = isGstNo;
    data['isShippingPrefs'] = isShippingPrefs;
    return data;
  }
}
