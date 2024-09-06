import 'package:al_rova/cubit/customer/get_edited_customer_cubit/get_edited_customer_state.dart';
import 'package:al_rova/repositories/customer/get_edited_customer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetEditedCustomerCubit extends Cubit<GetEditedCustomerState> {
  final GetEditedCustomerRepository getEditedCustomerRepository;

  GetEditedCustomerCubit({required this.getEditedCustomerRepository})
      : super(GetEditedCustomerInitial());

  Future<dynamic> getEditedCustomer(String customerId) async {
    emit(GetEditedCustomerLoading());
    final result =
        await getEditedCustomerRepository.getEditedCustomer(customerId);
    result.fold((failure) {
      emit(GetEditedCustomerError(failure.message));
    }, (r) {
      return emit(GetEditedCustomerSuccess(r));
    });
  }
}
