class CropDetailModel {
  Data? data;
  bool? success;
  String? errorMessage;
  String? resultMessage;

  CropDetailModel(
      {this.data, this.success, this.errorMessage, this.resultMessage});

  CropDetailModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    success = json['success'];
    errorMessage = json['errorMessage'];
    resultMessage = json['resultMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['success'] = success;
    data['errorMessage'] = errorMessage;
    data['resultMessage'] = resultMessage;
    return data;
  }
}

class Data {
  int? id;
  String? cropName;
  String? cropDiseaseName;
  List<String>? symptoms;
  List<String>? solutions;
  String? modelName;

  Data(
      {this.id,
      this.cropName,
      this.cropDiseaseName,
      this.symptoms,
      this.solutions,
      this.modelName});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropName = json['cropName'];
    cropDiseaseName = json['cropDiseaseName'];
    symptoms = json['symptoms'].cast<String>();
    solutions = json['solutions'].cast<String>();
    modelName = json['modelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cropName'] = cropName;
    data['cropDiseaseName'] = cropDiseaseName;
    data['symptoms'] = symptoms;
    data['solutions'] = solutions;
    data['modelName'] = modelName;
    return data;
  }
}
