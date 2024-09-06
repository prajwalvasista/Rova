import 'package:al_rova/models/customer/edited_customer/get_edited_customer_model.dart';
import 'package:equatable/equatable.dart';

abstract class GetEditedCustomerState extends Equatable {
  const GetEditedCustomerState();

  @override
  List<Object> get props => [];
}

class GetEditedCustomerInitial extends GetEditedCustomerState {}

class GetEditedCustomerLoading extends GetEditedCustomerState {}

class GetEditedCustomerError extends GetEditedCustomerState {
  final String message;
  const GetEditedCustomerError(this.message);

  @override
  List<Object> get props => [message];
}

class GetEditedCustomerSuccess extends GetEditedCustomerState {
  final GetEditedCustomerModel getEditedCustomerModel;

  const GetEditedCustomerSuccess(this.getEditedCustomerModel);

  @override
  List<Object> get props => [getEditedCustomerModel];
}
