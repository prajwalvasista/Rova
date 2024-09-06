class DeleteAccountModel {
  bool? success;
  String? errorMessage;
  String? resultMessage;

  DeleteAccountModel({
    this.success,
    this.errorMessage,
    this.resultMessage,
  });

  DeleteAccountModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    errorMessage = json['errorMessage'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['errorMessage'] = errorMessage;
    data['resultMessage'] = resultMessage;
    return data;
  }
}
