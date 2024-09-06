import 'package:al_rova/models/success/success_response_model.dart';
import 'package:equatable/equatable.dart';

abstract class EditCustomerState extends Equatable {
  const EditCustomerState();

  @override
  List<Object> get props => [];
}

class EditCustomerInitial extends EditCustomerState {}

class EditCustomerLoading extends EditCustomerState {}

class EditCustomerErrorState extends EditCustomerState {
  final String message;

  const EditCustomerErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class SuccessState extends EditCustomerState {
  final SuccessResponse successResponse;

  const SuccessState(this.successResponse);

  @override
  List<Object> get props => [successResponse];
}
