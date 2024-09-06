import 'package:al_rova/models/customer/crop/crop_detail_model.dart';
import 'package:al_rova/models/customer/crop/crop_disease_model.dart';
import 'package:al_rova/models/customer/crop/object_detection_model.dart';
import 'package:equatable/equatable.dart';

abstract class CropState extends Equatable {
  const CropState();

  @override
  List<Object> get props => [];
}

class CropInitalState extends CropState {}

class CropLoadingState extends CropState {}

// ignore: must_be_immutable
class CropSuccessState extends CropState {
  CropDiseaseModel cropDiseaseModel;

  CropSuccessState(this.cropDiseaseModel);

  @override
  List<Object> get props => [cropDiseaseModel];
}

class CropErrorState extends CropState {
  final String message;

  const CropErrorState(this.message);

  @override
  List<Object> get props => [message];
}

// ignore: must_be_immutable
class ObjectDetectionState extends CropState {
  ObjectDetectionModel objectDetectionModel;

  ObjectDetectionState(this.objectDetectionModel);

  @override
  List<Object> get props => [objectDetectionModel];
}

// ignore: must_be_immutable
class CropDetailState extends CropState {
  CropDetailModel cropDetailModel;

  CropDetailState(this.cropDetailModel);

  @override
  List<Object> get props => [cropDetailModel];
}
