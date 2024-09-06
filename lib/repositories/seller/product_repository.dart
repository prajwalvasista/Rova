import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/seller/product/get_ordered_product_count_model.dart';
import 'package:al_rova/models/seller/product/get_seller_details_model.dart';
import 'package:al_rova/models/seller/product/add_product_model.dart';
import 'package:al_rova/models/seller/product/get_all_product_model.dart';
import 'package:al_rova/models/seller/product/order_list_model.dart';
import 'package:al_rova/models/success/success_response_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ProductRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo;

  ProductRepository({required this.apiService, required this.networkInfo});

// add product repo
  Future<Either<Failure, AddProductModel>> addProduct(FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
            endPoint: APIEndPoints.addProduct, useToken: true, data: params);
        AddProductModel addProductModel =
            AddProductModel.fromJson(response.data);

        return Right(addProductModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

// add product repo
  Future<Either<Failure, SuccessResponse>> editProduct(
      FormData params, int productId, int id) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.put(
            endPoint: '${APIEndPoints.editProduct}$productId&Id=$id',
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

// get all products repo
  Future<Either<Failure, List<GetAllProductModel>>> getAllProducts() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: APIEndPoints.getAllProduct, useToken: true);
        List<GetAllProductModel> getAllProductlist = response.data
            .map<GetAllProductModel>(
                (item) => GetAllProductModel.fromJson(item))
            .toList();

        return Right(getAllProductlist);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // delete product repo
  Future<Either<Failure, SuccessResponse>> deleteProduct(
      int productId, String sellerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.delete(
          endPoint:
              '${APIEndPoints.deleteProduct}$productId&sellerId=$sellerId',
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

  // get products by id repo
  Future<Either<Failure, GetAllProductModel>> getProductById(
      int productId, String sellerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getProductById}$productId',
            useToken: true);
        GetAllProductModel getProductDetailsbyId =
            GetAllProductModel.fromJson(response.data);

        return Right(getProductDetailsbyId);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // get products by seller id repo
  Future<Either<Failure, List<GetAllProductModel>>> getProductBySellerId(
      String id) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getProductBySellerId}$id',
            useToken: true);
        List<GetAllProductModel> getProductByIdModel = response.data
            .map<GetAllProductModel>(
                (item) => GetAllProductModel.fromJson(item))
            .toList();

        return Right(getProductByIdModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // get seller details repo
  Future<Either<Failure, GetSellerDetailsModel>> getSellerDetails(
      String phoneNumber) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
            endPoint: '${APIEndPoints.getSellerDetailsByEmail}$phoneNumber',
            useToken: true);
        GetSellerDetailsModel getSellerDetailsModel =
            GetSellerDetailsModel.fromJson(response.data);
        return Right(getSellerDetailsModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // get order list repo
  Future<Either<Failure, List<OrderListModel>>> getAllOrderList(
      String sellerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getOrderdProducts}$sellerId',
            useToken: true);

        List<OrderListModel> getAllOrderList = response.data
            .map<OrderListModel>((item) => OrderListModel.fromJson(item))
            .toList();

        return Right(getAllOrderList);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  //approveOrder repo
  Future<Either<Failure, SuccessResponse>> approveOrder(FormData params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
            endPoint: APIEndPoints.orderApproval, useToken: true, data: params);
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

  //getTotalOrderdProductsForSeller repo
  Future<Either<Failure, GetOrderProductsCountModel>>
      getTotalOrderdProductsForSeller(String sellerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
          endPoint: '${APIEndPoints.getTotalOrderdProductsForSeller}$sellerId',
          useToken: true,
        );
        GetOrderProductsCountModel getOrderProductsCountModel =
            GetOrderProductsCountModel.fromJson(response.data);

        return Right(getOrderProductsCountModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
