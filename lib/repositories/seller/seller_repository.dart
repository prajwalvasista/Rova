import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/seller/complete_registration/add_seller_commercial_details_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class SellerRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo;

  SellerRepository({required this.apiService, required this.networkInfo});

// add address repo
  Future<Either<Failure, AddSellerCommercialDetailsModel>>
      addSellerCommercialDetails(FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
            endPoint: APIEndPoints.addSellerCommercialDetails,
            useToken: true,
            data: params);
        AddSellerCommercialDetailsModel addSellerCommercialDetailsModel =
            AddSellerCommercialDetailsModel.fromJson(response.data);

        return Right(addSellerCommercialDetailsModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

}
