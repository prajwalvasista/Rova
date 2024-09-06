class ObjectDetectionModel {
  bool? status;
  List<String>? objectList;
  String? message;
  int? statusCode;

  ObjectDetectionModel(
      {this.status, this.objectList, this.message, this.statusCode});

  ObjectDetectionModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    objectList = json['ObjectList'].cast<String>();
    message = json['Message'];
    statusCode = json['StatusCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['ObjectList'] = objectList;
    data['Message'] = message;
    data['StatusCode'] = statusCode;
    return data;
  }
}
