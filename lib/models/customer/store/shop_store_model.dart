class StoreShopModel {
  int? id;
  String? state;
  String? district;
  String? city;
  String? shopName;
  String? shopAddress;
  String? contactNumber;
  String? locationUrl;

  StoreShopModel(
      {this.id,
      this.state,
      this.district,
      this.city,
      this.shopName,
      this.shopAddress,
      this.contactNumber,
      this.locationUrl});

  StoreShopModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    district = json['district'];
    city = json['city'];
    shopName = json['shop_Name'];
    shopAddress = json['shop_Address'];
    contactNumber = json['contact_Number'];
    locationUrl = json['location_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['state'] = state;
    data['district'] = district;
    data['city'] = city;
    data['shop_Name'] = shopName;
    data['shop_Address'] = shopAddress;
    data['contact_Number'] = contactNumber;
    data['location_url'] = locationUrl;
    return data;
  }
}
