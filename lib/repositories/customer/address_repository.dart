import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/customer/address/address_response_model.dart';
import 'package:al_rova/models/success/success_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AddressRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo;

  AddressRepository({required this.apiService, required this.networkInfo});

// edit address repo
  Future<Either<Failure, SuccessResponse>> editAddress(
      int addressId, FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.put(
            endPoint: '${APIEndPoints.editAddress}$addressId',
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

// add address repo
  Future<Either<Failure, SuccessResponse>> addAddress(FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
            endPoint: APIEndPoints.addAddress, useToken: true, data: params);
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

// delete address repo
  Future<Either<Failure, SuccessResponse>> deleteAddress(
      int addressId, String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.delete(
          endPoint:
              '${APIEndPoints.deleteAddress}$addressId&customerId=$customerId',
          useToken: true,
        );
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

  Future<Either<Failure, SuccessResponse>> chooseAddressForCustomer(
      String customerId, int addressId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
            endPoint:
                '${APIEndPoints.chooseAddressOfCustomer}$customerId&addressId=$addressId',
            useToken: true);
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

  Future<Either<Failure, List<AddressResponseModel>>> getAllAddress(
      String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.allAddress}$customerId', useToken: true);
        List<AddressResponseModel> addressResponseModellist = response.data
            .map<AddressResponseModel>(
                (item) => AddressResponseModel.fromJson(item))
            .toList();

        return Right(addressResponseModellist);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  Future<Either<Failure, List<AddressResponseModel>>>
      getChoosedAddressByCustomer(String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getChoosedAddressByCustomer}$customerId',
            useToken: true);

        // print('Response status: ${response.statusCode}');
        // print('Response body: ${response.data}');
        List<AddressResponseModel> addressResponseModel = response.data
            .map<AddressResponseModel>(
                (item) => AddressResponseModel.fromJson(item))
            .toList();
        return Right(addressResponseModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
