class AddressResponseModel {
  int? addressId;
  String? customerId;
  String? name;
  String? phoneNumber;
  String? alternatePhoneNumber;
  String? city;
  String? state;
  String? country;
  String? zipcode;
  String? buildingName;
  String? areaColony;
  int? saveAddressAs;
  bool? makeAsDefaultAddress;
  bool? opensOnSaturday;
  bool? opensOnSunday;
  bool? isAddressSelected;

  AddressResponseModel(
      {this.addressId,
      this.customerId,
      this.name,
      this.phoneNumber,
      this.alternatePhoneNumber,
      this.city,
      this.state,
      this.country,
      this.zipcode,
      this.buildingName,
      this.areaColony,
      this.saveAddressAs,
      this.makeAsDefaultAddress,
      this.opensOnSaturday,
      this.opensOnSunday,
      this.isAddressSelected});

  AddressResponseModel.fromJson(Map<String, dynamic> json) {
    addressId = json['addressId'];
    customerId = json['customerId'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    alternatePhoneNumber = json['alternatePhoneNumber'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipcode = json['zipcode'];
    buildingName = json['buildingName'];
    areaColony = json['areaColony'];
    saveAddressAs = json['saveAddressAs'];
    isAddressSelected = json['isAddressSelected'];
    makeAsDefaultAddress = json['makeAsDefaultAddress'];
    opensOnSaturday = json['opensOnSaturday'];
    opensOnSunday = json['opensOnSunday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['addressId'] = addressId;
    data['customerId'] = customerId;
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    data['alternatePhoneNumber'] = alternatePhoneNumber;
    data['city'] = city;
    data['state'] = state;
    data['country'] = country;
    data['zipcode'] = zipcode;
    data['buildingName'] = buildingName;
    data['areaColony'] = areaColony;
    data['saveAddressAs'] = saveAddressAs;
    data['makeAsDefaultAddress'] = makeAsDefaultAddress;
    data['opensOnSaturday'] = opensOnSaturday;
    data['opensOnSunday'] = opensOnSunday;
    data['isAddressSelected'] = isAddressSelected;
    return data;
  }
}
