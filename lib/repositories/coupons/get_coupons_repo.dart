import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/coupons/apply_coupons.dart';
import 'package:al_rova/models/coupons/get_coupon_applied_for_customer_model.dart';

import 'package:al_rova/models/customer/order/coupon_model.dart';
import 'package:dartz/dartz.dart';

class GetCouponsRepo {
  final ApiService apiService;
  final NetworkInfo networkInfo;

  GetCouponsRepo({required this.apiService, required this.networkInfo});

  Future<Either<Failure, List<CouponModel>>> getAllCoupons(
      double amount, String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: "${APIEndPoints.getAllCoupons}$customerId&amount=$amount",
            useToken: true);
        List<CouponModel> couponModel = response.data
            .map<CouponModel>((item) => CouponModel.fromJson(item))
            .toList();
        return Right(couponModel);
      } catch (err) {
        return Left(ErrorHandler.handle(err).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  Future<Either<Failure, GetCouponAppliedForCustomerModel>>
      getAppliedCouponForCustomer(
          String customerId, int appliedCouponId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint:
                '${APIEndPoints.getCouponAppliedForCustomer}$customerId&appliedCouponId=$appliedCouponId',
            useToken: true);
        GetCouponAppliedForCustomerModel getCouponAppliedForCustomerModel =
            GetCouponAppliedForCustomerModel.fromJson(response.data);
        return Right(getCouponAppliedForCustomerModel);
      } catch (e) {
        return Left(ErrorHandler.handle(e).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  Future<Either<Failure, ApplyCouponModel>> applyCoupons(
      int couponId, String customerId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.post(
            endPoint:
                '${APIEndPoints.applyCoupons}$couponId&customerId=$customerId',
            useToken: true);
        ApplyCouponModel applyCouponModel =
            ApplyCouponModel.fromJson(response.data);
        return Right(applyCouponModel);
      } catch (err) {
        return Left(ErrorHandler.handle(err).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
