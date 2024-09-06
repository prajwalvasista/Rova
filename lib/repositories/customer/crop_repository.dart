import 'dart:io';

import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/customer/crop/crop_detail_model.dart';
import 'package:al_rova/models/customer/crop/crop_disease_model.dart';
import 'package:al_rova/models/customer/crop/object_detection_model.dart';
import 'package:dartz/dartz.dart';

class CropRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo;

  CropRepository({required this.apiService, required this.networkInfo});

  Future<Either<Failure, dynamic>> cropDiseaseName(String imagePath) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.imageUpload(
            endPoint: APIEndPoints.tomatoEndPoints,
            file: File(imagePath),
            useToken: false);
        if (response.data["StatusCode"] == 200) {
          CropDiseaseModel cropDiseaseModel =
              CropDiseaseModel.fromJson(response.data);
          return Right(cropDiseaseModel);
        } else {
          ObjectDetectionModel objectDetectionModel =
              ObjectDetectionModel.fromJson(response.data);
          return Right(objectDetectionModel);
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  Future<Either<Failure, dynamic>> getCropInfo(String diseaseModelName) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
          endPoint: "${APIEndPoints.cropDetails}$diseaseModelName",
        );

        CropDetailModel cropDetailModel =
            CropDetailModel.fromJson(response.data);
        return Right(cropDetailModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
