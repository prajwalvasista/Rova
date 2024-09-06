import 'package:al_rova/models/seller/complete_registration/add_seller_commercial_details_model.dart';
import 'package:equatable/equatable.dart';

abstract class SellerCommercialDetailsState extends Equatable {
  const SellerCommercialDetailsState();
}

class SellerCommercialDetailsInitialState extends SellerCommercialDetailsState {
  @override
  List<Object?> get props => [];
}

class SellerCommercialDetailsLoadingState extends SellerCommercialDetailsState {
  @override
  List<Object?> get props => [];
}

class SellerCommercialDetailsSuccessState extends SellerCommercialDetailsState {
  final AddSellerCommercialDetailsModel addSellerCommercialDetailsModel;

  const SellerCommercialDetailsSuccessState(
      this.addSellerCommercialDetailsModel);

  @override
  List<Object?> get props => [addSellerCommercialDetailsModel];
}

class SellerCommercialDetailsErrorState extends SellerCommercialDetailsState {
  final String errorMessage;

  const SellerCommercialDetailsErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
