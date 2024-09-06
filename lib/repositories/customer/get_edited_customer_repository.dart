import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/customer/edited_customer/get_edited_customer_model.dart';
import 'package:dartz/dartz.dart';

class GetEditedCustomerRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo;

  GetEditedCustomerRepository(
      {required this.apiService, required this.networkInfo});

  Future<Either<Failure, GetEditedCustomerModel>> getEditedCustomer(
      String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getEditedCustomer}$customerId',
            useToken: true);
        GetEditedCustomerModel getEditedCustomerModel =
            GetEditedCustomerModel.fromJson(response.data);
        return Right(getEditedCustomerModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
