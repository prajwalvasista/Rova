import 'dart:convert';
import 'package:al_rova/common/widget/empty_widget.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/customer/product_cubit/product_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/common_search_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/customer/my_order/widget/common_text_widget.dart';
import 'package:al_rova/views/customer/order_detail/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'filter_modal.dart';

class MyOrders extends StatefulWidget {
  const MyOrders({super.key});

  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  final TextEditingController _searchController = TextEditingController();

  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  @override
  void initState() {
    super.initState();
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    context
        .read<CustomerProductCubit>()
        .getOrderedProductsForCustomer(userModel!.response!.roleId!);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterModal() async {
    final filters = await showModalBottomSheet<Map<String, List<String>>>(
      context: context,
      builder: (context) => const FilterModal(),
    );

    if (filters != null) {
      print('Selected filters: $filters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: true,
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocBuilder<CustomerProductCubit, ProductState>(
        builder: (context, state) {
          if (state is GetOrderedProductForCustomerSuccess &&
              state.getOrderedProductForCustomerModel.isEmpty) {
            return const EmptyWidget(
              message: "Oops! No orders found",
            );
          }
          if (state is ProductLoadingState) {
            return const SpinKitIndicator(
              type: SpinKitType.circle,
            );
          }
          if (state is ProductErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomToast(context, state.message, true);
            });
          }
          if (state is GetOrderedProductForCustomerSuccess) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CommonSearchBox(
                            textEditingController: _searchController,
                            fillColor: AppColors.white,
                            filled: false,
                            isSuffix: false,
                            hintText: AppStrings.searchProducts),
                      ),
                      IconButton(
                        onPressed: _showFilterModal,
                        icon: const Icon(
                          Icons.filter_list_alt,
                          color: AppColors.primary,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return OrderInfoCard(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => CustomerProductCubit(
                                    customerProductRepository: getIt(),
                                  ),
                                  child: OrderDetails(
                                    orderId: state
                                        .getOrderedProductForCustomerModel[
                                            index]
                                        .orderId!,
                                  ),
                                ),
                              ),
                            );
                          },
                          text: "Delivery expected by fri mar 22",
                          subText: state
                              .getOrderedProductForCustomerModel[index].name!,
                          image: state.getOrderedProductForCustomerModel[index]
                              .images![0],
                        );
                      },
                      itemCount: state.getOrderedProductForCustomerModel.length,
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
