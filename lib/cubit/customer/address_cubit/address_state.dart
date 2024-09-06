import 'package:al_rova/models/customer/address/address_response_model.dart';
import 'package:al_rova/models/success/success_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressLoadingState extends AddressState {}

// ignore: must_be_immutable
class AddressSuccessState extends AddressState {
  List<AddressResponseModel> addressResponseModel;
  AddressSuccessState(this.addressResponseModel);

  @override
  List<Object> get props => [addressResponseModel];
}

class AddressErrorState extends AddressState {
  final String message;

  const AddressErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class SuccessState extends AddressState {
  final SuccessResponse successResponse;

  const SuccessState(this.successResponse);

  @override
  List<Object> get props => [successResponse];
}
