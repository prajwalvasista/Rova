import 'package:al_rova/models/coupons/apply_coupons.dart';
import 'package:al_rova/models/coupons/get_coupon_applied_for_customer_model.dart';
import 'package:al_rova/models/customer/order/coupon_model.dart';
import 'package:equatable/equatable.dart';

abstract class GetCouponsState extends Equatable {
  const GetCouponsState();
  @override
  List<Object> get props => [];
}

class GetCouponsInitial extends GetCouponsState {}

class GetCouponLoading extends GetCouponsState {}

class GetCouponError extends GetCouponsState {
  final String message;

  const GetCouponError({required this.message});

  @override
  List<Object> get props => [message];
}

// ignore: must_be_immutable
class GetCouponSuccess extends GetCouponsState {
  List<CouponModel> couponModel;
  GetCouponSuccess(this.couponModel);
  @override
  List<Object> get props => [couponModel];
}

// ignore: must_be_immutable
class ApplyCouponSuccess extends GetCouponsState {
  ApplyCouponModel applyCouponModel;
  ApplyCouponSuccess(this.applyCouponModel);
  @override
  List<Object> get props => [applyCouponModel];
}

// ignore: must_be_immutable
class GetCouponAppliedForCustomer extends GetCouponsState {
  GetCouponAppliedForCustomerModel getCouponAppliedForCustomerModel;
  GetCouponAppliedForCustomer(this.getCouponAppliedForCustomerModel);
  @override
  List<Object> get props => [getCouponAppliedForCustomerModel];
}
