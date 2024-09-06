class CropDiseaseModel {
  String? type;
  double? accuracy;
  int? statusCode;

  CropDiseaseModel({this.type, this.accuracy, this.statusCode});

  CropDiseaseModel.fromJson(Map<String, dynamic> json) {
    type = json['class'];
    accuracy = json['accuracy'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['class'] = type;
    data['accuracy'] = accuracy;
    data['StatusCode'] = statusCode;
    return data;
  }
}
