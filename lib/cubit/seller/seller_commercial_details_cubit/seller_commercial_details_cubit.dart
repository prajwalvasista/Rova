import 'package:al_rova/cubit/seller/seller_commercial_details_cubit/seller_commercial_details_state.dart';
import 'package:al_rova/repositories/seller/seller_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SellerCommercialDetailsCubit extends Cubit<SellerCommercialDetailsState> {
  final SellerRepository sellerRepository;
  SellerCommercialDetailsCubit({required this.sellerRepository})
      : super(SellerCommercialDetailsInitialState());

// add seller commercial details cubit
  addSellerCommercialDetails(FormData params) async {
    emit(SellerCommercialDetailsLoadingState());
    try {
      var result = await sellerRepository.addSellerCommercialDetails(params);
      result.fold(
        (failure) {
          emit(SellerCommercialDetailsErrorState(failure.errorMessage));
        },
        ((response) {
          print('response===> $response');

          return emit(SellerCommercialDetailsSuccessState(response));
        }),
      );
    } catch (err) {
      emit(SellerCommercialDetailsErrorState(err.toString()));
    }
  }
}
