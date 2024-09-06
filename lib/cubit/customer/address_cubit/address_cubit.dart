import 'package:al_rova/cubit/customer/address_cubit/address_state.dart';
import 'package:al_rova/repositories/customer/address_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddressCubit extends Cubit<AddressState> {
  final AddressRepository addressRepository;
  AddressCubit({required this.addressRepository}) : super(AddressInitial());

// fetch all address cubit
  Future<dynamic> fetchAllAddress(String customerId) async {
    emit(AddressLoadingState());

    final result = await addressRepository.getAllAddress(customerId);
    result.fold((failure) {
      emit(AddressErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(AddressSuccessState(r));
    });
  }

  Future<dynamic> getChoosedAddressByCustomer(String customerId) async {
    emit(AddressLoadingState());
    final res = await addressRepository.getChoosedAddressByCustomer(customerId);
    res.fold((failure) {
      emit(AddressErrorState(failure.message));
    }, (r) {
      return emit(AddressSuccessState(r));
    });
  }

// edit address cubit
  Future<dynamic> editAddress(int addressId, FormData params) async {
    emit(AddressLoadingState());

    final result = await addressRepository.editAddress(addressId, params);
    result.fold((failure) {
      emit(AddressErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(SuccessState(r));
    });
  }

// add address cubit
  Future<dynamic> addAddress(FormData params) async {
    emit(AddressLoadingState());

    final result = await addressRepository.addAddress(params);
    result.fold((failure) {
      emit(AddressErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(SuccessState(r));
    });
  }

// delete address cubit
  Future<dynamic> deleteAddress(int addressId, String customerId) async {
    emit(AddressLoadingState());
    final result = await addressRepository.deleteAddress(addressId, customerId);
    result.fold((failure) {
      emit(AddressErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(SuccessState(r));
    });
  }

  Future<dynamic> chooseAddressOfCustomer(
      int addressId, String customerId) async {
    emit(AddressLoadingState());
    final res =
        await addressRepository.chooseAddressForCustomer(customerId, addressId);
    res.fold((failure) {
      emit(AddressErrorState(failure.message));
    }, (r) {
      return emit(SuccessState(r));
    });
  }
}
