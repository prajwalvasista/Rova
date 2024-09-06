import 'dart:convert';
import 'dart:io';

import 'package:al_rova/common/widget/empty_widget.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/address_cubit/address_cubit.dart';
import 'package:al_rova/cubit/customer/address_cubit/address_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/models/customer/address/address_response_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/customer/address/add_new_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseAddress extends StatefulWidget {
  const ChooseAddress({super.key});

  @override
  State<ChooseAddress> createState() => _ChooseAddressState();
}

class _ChooseAddressState extends State<ChooseAddress> {
  int selectedIndex = -1;
  int addressId = 0;
  MySharedPref? mySharedPref;
  late AddressResponseModel addressResponseModel;
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  @override
  void initState() {
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    context.read<AddressCubit>().fetchAllAddress(userModel!.response!.roleId!);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   context.read<AddressCubit>().fetchAllAddress();

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Platform.isAndroid
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_back_ios_new_rounded,
              color: AppColors.white,
            )),
        title: Text(
          'Choose Address',
          style: headLine2.copyWith(color: AppColors.white, fontSize: 20),
        ),
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is AddressSuccessState &&
              state.addressResponseModel.isEmpty) {
            return Column(
              children: [
                const EmptyWidget(
                  message: "No address found",
                ),
                CommonButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                AddressCubit(addressRepository: getIt()),
                            child: AddNewAddress(
                              isEdit: false,
                            ),
                          ),
                        ))
                        .then((value) => context
                            .read<AddressCubit>()
                            .fetchAllAddress(userModel!.response!.roleId!));
                  },
                  buttonText: '+ Add new Address',
                  buttonColor: AppColors.primary,
                  buttonTextColor: AppColors.white,
                  height: 50,
                )
              ],
            );
          }
          if (state is AddressLoadingState) {
            return const SpinKitIndicator(
              type: SpinKitType.circle,
            );
          }
          if (state is AddressErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomToast(context, state.message, true);
            });
          }
          if (state is AddressSuccessState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) =>
                                AddressCubit(addressRepository: getIt()),
                            child: AddNewAddress(
                              isEdit: false,
                            ),
                          ),
                        ))
                        .then((value) => context
                            .read<AddressCubit>()
                            .fetchAllAddress(userModel!.response!.roleId!));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    color: const Color(0xff98FF8F),
                    child: Text(
                      '+ Add new Address',
                      style: headLine4.copyWith(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.addressResponseModel.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                            addressResponseModel =
                                state.addressResponseModel[index];
                            addressId =
                                state.addressResponseModel[index].addressId!;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: index == selectedIndex
                                      ? AppColors.primary
                                      : const Color(0xffC9C9C9),
                                  width: index == selectedIndex ? 2 : 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0)
                                      .copyWith(bottom: 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.addressResponseModel[index]
                                                      .name ??
                                                  "", // 'Ranjit Kumar',
                                              style: headLine2,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              decoration: BoxDecoration(
                                                  color: AppColors.lightGary,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                  child: Text(
                                                '${state.addressResponseModel[index].saveAddressAs}' ==
                                                        '1'
                                                    ? 'HOME'
                                                    : 'WORK',
                                                style: headLine6.copyWith(
                                                    color: AppColors.black),
                                              )),
                                            )
                                          ],
                                        ),
                                      ),
                                      state.addressResponseModel[index]
                                              .makeAsDefaultAddress!
                                          ? Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: AppColors.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                  child: Text(
                                                state
                                                        .addressResponseModel[
                                                            index]
                                                        .makeAsDefaultAddress!
                                                    ? 'Default'
                                                    : " ",
                                                style: headLine2.copyWith(
                                                    color: AppColors.white,
                                                    fontSize: 13),
                                              )),
                                            )
                                          : const SizedBox()
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0)
                                      .copyWith(top: 2, bottom: 0),
                                  child: Text(
                                    '${state.addressResponseModel[index].areaColony}, ${state.addressResponseModel[index].buildingName} , ${state.addressResponseModel[index].city}, ${state.addressResponseModel[index].state}, ${state.addressResponseModel[index].state}, ${state.addressResponseModel[index].zipcode}, ${state.addressResponseModel[index].country}',
                                    style: headLine5.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0)
                                      .copyWith(top: 3),
                                  child: SizedBox(
                                    child: Text(
                                      'Phone: ${state.addressResponseModel[index].phoneNumber}' ??
                                          "",
                                      style: headLine4.copyWith(
                                          color: AppColors.gary),
                                    ),
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  color: AppColors.lightGary,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BlocProvider(
                                                      create: (context) =>
                                                          AddressCubit(
                                                              addressRepository:
                                                                  getIt()),
                                                      child: AddNewAddress(
                                                        isEdit: true,
                                                        data: state
                                                                .addressResponseModel[
                                                            index],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .then((value) => context
                                                    .read<AddressCubit>()
                                                    .fetchAllAddress(userModel!
                                                        .response!.roleId!));
                                          },
                                          child: Text(
                                            'Edit',
                                            style: headLine4.copyWith(
                                                color: AppColors.subtitleColor,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: InkWell(
                                            onTap: () {
                                              deleteAddressDialogBuilder(
                                                      context,
                                                      state
                                                          .addressResponseModel[
                                                              index]
                                                          .addressId!)
                                                  .then((value) => context
                                                      .read<AddressCubit>()
                                                      .fetchAllAddress(
                                                          userModel!.response!
                                                              .roleId!));
                                            },
                                            child: Text(
                                              'Delete',
                                              style: headLine4.copyWith(
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            );
          }
          return const SizedBox();
        },
      ),
      bottomNavigationBar: selectedIndex != -1
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonButton(
                onPressed: selectedIndex >= 0
                    ? () {
                        Navigator.of(context).pop();
                        context.read<AddressCubit>().chooseAddressOfCustomer(
                            addressId, userModel!.response!.roleId!);
                        //     .then((value) {
                        //   context.read<AddressCubit>().getChoosedAddressByCustomer(
                        //       userModel!.response!.roleId!);
                        // });
                      }
                    : () {},
                buttonText: 'DELIVER HERE',
                buttonColor:
                    selectedIndex >= 0 ? AppColors.primary : AppColors.gary,
                buttonTextColor: AppColors.white,
                width: MediaQuery.of(context).size.width,
                height: 50,
              ),
            )
          : const SizedBox(),
    );
  }

  // delete address dialog
  Future<void> deleteAddressDialogBuilder(BuildContext context, int addressId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => AddressCubit(addressRepository: getIt()),
          child: BlocConsumer<AddressCubit, AddressState>(
            listener: (context, state) {
              if (state is SuccessState) {
                Navigator.of(context).pop();
                showCustomToast(context, state.successResponse.message!, false);
              }
              if (state is AddressErrorState) {
                Navigator.of(context).pop();
                showCustomToast(context, state.message, false);
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  AlertDialog(
                    content: SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.deleteAdd,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: Fonts.poppins,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            AppStrings.deleteAddMsg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.gary,
                              fontFamily: Fonts.poppins,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                              fontFamily: Fonts.poppins, color: AppColors.gary),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primary,
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              fontFamily: Fonts.poppins,
                              color: AppColors.white),
                        ),
                        onPressed: () {
                          context.read<AddressCubit>().deleteAddress(
                              addressId, userModel!.response!.roleId!);
                          // setState(() {});
                        },
                      )
                    ],
                  ),
                  if (state is AddressLoadingState)
                    const Center(child: CircularProgressIndicator())
                ],
              );
            },
          ),
        );
      },
    );
  }
}
