class GetEditedCustomerModel {
  String? name;
  String? phoneNumber;

  GetEditedCustomerModel({this.name, this.phoneNumber});

  GetEditedCustomerModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['phoneNumber'] = phoneNumber;
    return data;
  }
}
