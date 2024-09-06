import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/success/success_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class EditCustomerRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo;

  EditCustomerRepository({required this.apiService, required this.networkInfo});

  Future<Either<Failure, SuccessResponse>> editCustomer(
      String customerId, Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.put(
            endPoint: '${APIEndPoints.editCustomer}$customerId',
            useToken: true,
            data: params);
        SuccessResponse successResponse =
            SuccessResponse.fromJson(response.data);
        return Right(successResponse);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
