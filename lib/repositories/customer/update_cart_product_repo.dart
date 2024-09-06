import 'dart:convert';

import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/customer/product/add_update_delete_product_to_cart_model.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:dartz/dartz.dart';

class UpdateCartProductRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo;
  final MySharedPref mySharedPref;

  UpdateCartProductRepository(
      {required this.apiService,
      required this.networkInfo,
      required this.mySharedPref});

  // updateProductInCart repo
  Future<Either<Failure, AddEditDeleteProductToCartModel>> updateProductInCart(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.patch(
          endPoint: APIEndPoints.updateProductInCart,
          useToken: true,
          data: jsonEncode(params),
        );
        AddEditDeleteProductToCartModel addEditDeleteProductToCartModel =
            AddEditDeleteProductToCartModel.fromJson(response.data);

        return Right(addEditDeleteProductToCartModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
