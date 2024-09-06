import 'dart:convert';

import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/customer/product/add_update_delete_product_to_cart_model.dart';
import 'package:al_rova/models/customer/product/get_all_category.dart';
import 'package:al_rova/models/customer/product/get_all_product_model.dart';
import 'package:al_rova/models/customer/product/get_all_wishlist_product.dart';
import 'package:al_rova/models/customer/product/get_count_of_wishlist_cart_product_model.dart';
import 'package:al_rova/models/customer/product/view_product_in_cart_model.dart';
import 'package:al_rova/models/customer/order/get_ordered_product_for_customer_model.dart';
import 'package:al_rova/models/success/success_response_model.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:dartz/dartz.dart';

class CustomerProductRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo;
  final MySharedPref mySharedPref;

  CustomerProductRepository(
      {required this.apiService,
      required this.networkInfo,
      required this.mySharedPref});

// get all products repo
  Future<Either<Failure, List<GetAllProductModel>>> getAllProducts(
      String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getAllProduct}$customerId',
            useToken: true);
        List<GetAllProductModel> getAllProductlist = response.data
            .map<GetAllProductModel>(
                (item) => GetAllProductModel.fromJson(item))
            .toList();
        getAllCategory();
        return Right(getAllProductlist);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // get products by id repo
  Future<Either<Failure, GetAllProductModel>> getProductById(
      int productId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getProductById}$productId',
            useToken: true);
        GetAllProductModel getAllProductModel =
            GetAllProductModel.fromJson(response.data);

        return Right(getAllProductModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // cart releted repo

  // addProductToCart repo
  Future<Either<Failure, AddEditDeleteProductToCartModel>> addProductToCart(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
          endPoint: APIEndPoints.addProductToCart,
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

  // viewProductInCart repo
  Future<Either<Failure, List<ViewProductInCartModel>>> viewProductInCart(
      String id) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
          endPoint: '${APIEndPoints.viewProductInCart}$id',
          useToken: true,
        );
        print('response===> ${response.data['response']}');
        List<ViewProductInCartModel> getAllCartProduct = response
            .data['response']
            .map<ViewProductInCartModel>(
                (item) => ViewProductInCartModel.fromJson(item))
            .toList();
        return Right(getAllCartProduct);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

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

  // updateProductInCart repo
  Future<Either<Failure, AddEditDeleteProductToCartModel>>
      deleteProductFromCart(String customerId, int productId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.delete(
          endPoint:
              '${APIEndPoints.deleteProductFromCart}$customerId&productId=$productId',
          useToken: true,
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

  // addProductToWishlist repo
  Future<Either<Failure, SuccessResponse>> addProductToWishlist(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
          endPoint: APIEndPoints.addToWishList,
          useToken: true,
          data: jsonEncode(params),
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

  // get wishlist all products repo
  Future<Either<Failure, List<GetAllWishlistProductModel>>>
      getAllWishlistProducts(String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getWishListByCustomerId}$customerId',
            useToken: true);
        List<GetAllWishlistProductModel> getAllProductlist = response.data
            .map<GetAllWishlistProductModel>(
                (item) => GetAllWishlistProductModel.fromJson(item))
            .toList();
        return Right(getAllProductlist);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // delete product form wislist  repo
  Future<Either<Failure, SuccessResponse>> deleteProductFromWishlist(
      String customerId, int productId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.delete(
            endPoint:
                '${APIEndPoints.deleteProductsFromWishList}$customerId&productId=$productId',
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

  // orderAProduct repo
  Future<Either<Failure, AddEditDeleteProductToCartModel>> orderAProduct(
      String customerId, int productId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
          endPoint:
              '${APIEndPoints.placeOrder}$productId&customerId=$customerId',
          useToken: true,
          // data: jsonEncode(params),
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

  //getOrderedProductsForCustomer
  Future<Either<Failure, List<GetOrderedProductForCustomerModel>>>
      getOrderedProductsForCustomer(String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getOrderedProductForCustomer}$customerId',
            useToken: true);
        List<GetOrderedProductForCustomerModel>
            getOrderedProductForCustomerModel = response.data
                .map<GetOrderedProductForCustomerModel>(
                    (item) => GetOrderedProductForCustomerModel.fromJson(item))
                .toList();
        return Right(getOrderedProductForCustomerModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // getCountOfWishlistAndCartProduct repo
  Future<Either<Failure, GetCountofWishlistAndCartProducts>>
      getCountOfWishlistAndCartProduct(String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
          endPoint:
              '${APIEndPoints.getProductCountInWishlistAndCart}$customerId',
          useToken: true,
        );
        GetCountofWishlistAndCartProducts getCountofWishlistAndCartProducts =
            GetCountofWishlistAndCartProducts.fromJson(response.data);

        return Right(getCountofWishlistAndCartProducts);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  // getAllSimilarProducts repo
  Future<Either<Failure, List<GetAllProductModel>>> getAllSimilarProducts(
      String category) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: '${APIEndPoints.getSimilarProducts}$category',
            useToken: true);
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

  // GetAllCategory repo
  Future<Either<Failure, GetAllCategory>> getAllCategory() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: APIEndPoints.getAllProductCategory, useToken: true);
        GetAllCategory getAllCategory = GetAllCategory.fromJson(response.data);
        return Right(getAllCategory);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  //getordersbyorderIdandCustomerId
  Future<Either<Failure, GetOrderedProductForCustomerModel>>
      getOrderedProductForCustomerId(String customerId, String orderId) async {
    if (await networkInfo.isConnected) {
      try {
        final res = await apiService.get(
            endPoint:
                '${APIEndPoints.getOrdersByOrderIdAndCustomerId}$customerId&orderId=$orderId',
            useToken: true);
        GetOrderedProductForCustomerModel getOrderedProductForCustomerModel =
            GetOrderedProductForCustomerModel.fromJson(res.data);
        return Right(getOrderedProductForCustomerModel);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
