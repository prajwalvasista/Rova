import 'dart:convert';

import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/edit_customer_cubit/edit_customer_cubit.dart';
import 'package:al_rova/cubit/customer/edit_customer_cubit/edit_customer_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/common_input_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/customer/profile/widget/textfield_lable.dart';
// import 'package:al_rova/views/dashboard/profile/common_text_field.dart';
// import 'package:al_rova/views/dashboard/profile/common_text_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final SizedBox defaultGap = const SizedBox(height: 15);
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  @override
  void initState() {
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    if (userModel != null) {
      firstNameController.text = userModel!.response?.name ?? '';
      emailController.text = userModel!.response?.email ?? '';
      mobileController.text = userModel!.response?.phoneNumber ?? '';
    }

    // firstNameController.text = userModel!.response!.name!;

    // emailController.text = userModel!.response!.email!;
    // mobileController.text = userModel!.response!.phoneNumber!;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 20,
        leading: const SizedBox(),
        centerTitle: true,
        leadingWidth: 0,
        backgroundColor: AppColors.primary,
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: AppColors.textColor,
            fontSize: 22,
          ),
        ),
      ),
      body: BlocConsumer<EditCustomerCubit, EditCustomerState>(
        listener: (context, state) {
          if (state is EditCustomerErrorState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showCustomToast(context, state.message, true);
            });
          }
          if (state is SuccessState) {
            showCustomToast(context, state.successResponse.message!, false);
          }
        },
        builder: (context, state) {
          if (state is EditCustomerLoading) {
            return const SpinKitIndicator(
              type: SpinKitType.circle,
            );
          }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 220,
                  width: MediaQuery.of(context).size.width,
                  color: AppColors.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 90,
                            backgroundColor: AppColors.circleAvatarBgColor,
                            child: Image.asset(
                              scale: 5,
                              Images.profile,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 90,
                          child: ClipOval(
                            child: Material(
                              color: AppColors.circleAvatarBgColor,
                              child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                defaultGap,
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextFieldLabel(text: AppStrings.firstName),
                        const SizedBox(height: 10),
                        CommonInputBox(
                          // validator: (p0) {
                          //   RegExp nameValidation = RegExp(r'(a-zA-Z)');
                          //   if (p0 == null || p0.isEmpty) {
                          //     return AppStrings.enterName;
                          //   } else if (!nameValidation.hasMatch(p0)) {
                          //     return AppStrings.enterCorrectName;
                          //   } else {
                          //     return "";
                          //   }
                          // },
                          controller: firstNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 25),
                        const TextFieldLabel(text: AppStrings.lastName),
                        const SizedBox(height: 10),
                        CommonInputBox(
                          controller: lastNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                        // const SizedBox(height: 25),
                        // const TextFieldLabel(text: AppStrings.emailId),
                        // const SizedBox(height: 10),
                        // CommonInputBox(
                        //   validator: (p0) {
                        //     RegExp emailVAlidation =
                        //         RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
                        //     if (p0 == null || p0.isEmpty) {
                        //       return AppStrings.enterEmailAddress;
                        //     } else if (!emailVAlidation.hasMatch(p0)) {
                        //       return AppStrings.enterCorrectEmailAddress;
                        //     } else {
                        //       return null;
                        //     }
                        //   },
                        //   controller: emailController,
                        //   keyboardType: TextInputType.emailAddress,
                        //   textInputAction: TextInputAction.next,
                        // ),
                        const SizedBox(height: 25),
                        const TextFieldLabel(text: AppStrings.mobileNo),
                        const SizedBox(height: 10),
                        CommonInputBox(
                          maxLength: 10,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return AppStrings.phoneNoErrorMsg;
                            } else if (val.length < 10) {
                              return AppStrings.phoneNoErrorMsg;
                            }
                            return null;
                          },
                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CommonButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              Map<String, dynamic> params = <String, dynamic>{};
              params = {
                "name": firstNameController.text.toString().trim(),
                "lastName": lastNameController.text.toString().trim(),
                "phoneNumber": mobileController.text.toString().trim()
              };
              context
                  .read<EditCustomerCubit>()
                  .editCustomer(userModel!.response!.roleId!, params);
            }
          },
          buttonText: 'Edit',
          buttonColor: AppColors.primary,
          buttonTextColor: AppColors.white,
          height: 48,
          fontSize: 18,
        ),
      ),
    );
  }
}
