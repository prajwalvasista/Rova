
import 'package:al_rova/cubit/coupons/get_coupons_state.dart';
import 'package:al_rova/repositories/coupons/get_coupons_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetCouponsCubit extends Cubit<GetCouponsState> {
  final GetCouponsRepo getCouponsRepo;

  GetCouponsCubit({required this.getCouponsRepo}) : super(GetCouponsInitial());

  Future<dynamic> getAllCoupons(double amount, String customerId) async {
    emit(GetCouponLoading());
    final result = await getCouponsRepo.getAllCoupons(amount, customerId);
    result.fold((failure) {
      emit(GetCouponError(message: failure.message));
    }, (r) {
      return emit(GetCouponSuccess(r));
    });
  }

  Future<dynamic> getAppliedCouponsForCustomer(
      String customerId, int appliedCouponId) async {
    emit(GetCouponLoading());
    final result = await getCouponsRepo.getAppliedCouponForCustomer(
        customerId, appliedCouponId);
    result.fold((failure) {
      emit(GetCouponError(message: failure.message));
    }, (r) {
      return emit(GetCouponAppliedForCustomer(r));
    });
  }

  Future<dynamic> applyCoupons(int couponId, String customerId) async {
    emit(GetCouponLoading());
    final res = await getCouponsRepo.applyCoupons(couponId, customerId);
    res.fold((failure) {
      emit(GetCouponError(message: failure.message));
    }, (r) {
      return emit(ApplyCouponSuccess(r));
    });
  }
}
