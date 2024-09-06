class VerifyOtpModel {
  bool? success;
  int? statusCode;
  String? errorMessage;
  Response? response;

  VerifyOtpModel(
      {this.success, this.statusCode, this.errorMessage, this.response});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    errorMessage = json['errorMessage'];
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['statusCode'] = statusCode;
    data['errorMessage'] = errorMessage;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  String? roleId;
  String? name;
  String? email;
  String? phoneNumber;
  String? token;
  bool? success;
  String? errorMessage;

  Response(
      {this.roleId,
      this.name,
      this.email,
      this.phoneNumber,
      this.token,
      this.success,
      this.errorMessage});

  Response.fromJson(Map<String, dynamic> json) {
    roleId = json['roleId'];
    name = json['name'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    token = json['token'];
    success = json['success'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roleId'] = roleId;
    data['name'] = name;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['token'] = token;
    data['success'] = success;
    data['errorMessage'] = errorMessage;
    return data;
  }
}
