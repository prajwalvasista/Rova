import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
import 'package:al_rova/repositories/customer/customer_product_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomerProductCubit extends Cubit<ProductState> {
  final CustomerProductRepository customerProductRepository;
  CustomerProductCubit({required this.customerProductRepository})
      : super(ProductInitialState());

// fetch all product cubit
  Future<dynamic> fetchAllProduct(String customerId) async {
    emit(ProductLoadingState());
    final result = await customerProductRepository.getAllProducts(customerId);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(GetProductSuccessState(r));
    });
  }

// get product by id cubit
  Future<dynamic> getProductById(int productId) async {
    emit(ProductLoadingState());
    final result = await customerProductRepository.getProductById(productId);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(GetProductByIdSuccessState(r));
    });
  }

// addProductToCart cubit
  Future<dynamic> addProductToCart(Map<String, dynamic> params) async {
    emit(ProductLoadingState());
    final result = await customerProductRepository.addProductToCart(params);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(AddEditDeleteProductToCartSuccessState(r));
    });
  }

// updateProductInCart cubit
  Future<dynamic> updateProductInCart(Map<String, dynamic> params) async {
    //emit(ProductLoadingState());
    final result = await customerProductRepository.updateProductInCart(params);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(AddEditDeleteProductToCartSuccessState(r));
    });
  }

// viewProductInCart cubit
  Future<dynamic> viewProductInCart(String id) async {
    emit(ProductLoadingState());
    final result = await customerProductRepository.viewProductInCart(id);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(ViewProductInCartSuccessState(r));
    });
  }

// deleteProductFromCart cubit
  Future<dynamic> deleteProductFromCart(
      String customerId, int productId) async {
    //emit(ProductLoadingState());
    final result = await customerProductRepository.deleteProductFromCart(
        customerId, productId);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(AddEditDeleteProductToCartSuccessState(r));
    });
  }

  // addProductToWishlist cubit
  Future<dynamic> addProductToWishlist(Map<String, dynamic> params) async {
    // emit(ProductLoadingState());
    final result = await customerProductRepository.addProductToWishlist(params);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(SuccessState(r));
    });
  }

// fetch all product cubit
  Future<dynamic> getAllWishlistProduct(String customerId) async {
    emit(ProductLoadingState());
    final result =
        await customerProductRepository.getAllWishlistProducts(customerId);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(GetWishlistProductSuccessState(r));
    });
  }

// fetch all product cubit
  Future<dynamic> deleteProductFromWishlist(
      String customerId, int productId) async {
    emit(ProductLoadingState());
    final result = await customerProductRepository.deleteProductFromWishlist(
        customerId, productId);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(SuccessState(r));
    });
  }

  // addProductToCart cubit
  Future<dynamic> orderAProduct(String customerId, int productId) async {
    emit(ProductLoadingState());
    final result =
        await customerProductRepository.orderAProduct(customerId, productId);
    result.fold((failure) {
      emit(ProductErrorState(failure.message));
      // return [];
    }, (r) {
      return emit(AddEditDeleteProductToCartSuccessState(r));
    });
  }

  //getOrderedProductsForCustomer
  Future<dynamic> getOrderedProductsForCustomer(String customerId) async {
    emit(ProductLoadingState());
    final res = await customerProductRepository
        .getOrderedProductsForCustomer(customerId);
    res.fold((failure) {
      emit(ProductErrorState(failure.message));
    }, (r) {
      return emit(GetOrderedProductForCustomerSuccess(r));
    });
  }

  //getOrdersByOrderIdAndCustomerId

  Future<dynamic> getOrdersByOrderIdAndCustomerId(
      String customerId, String orderId) async {
    emit(ProductLoadingState());
    final response = await customerProductRepository
        .getOrderedProductForCustomerId(customerId, orderId);
    response.fold((failure) {
      emit(ProductErrorState(failure.message));
    }, (r) {
      return emit(GetOrderByOrderIdAndCustomerIdSuccess(r));
    });
  }
}
