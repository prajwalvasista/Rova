import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/auth_cubit/auth_cubit.dart';
import 'package:al_rova/cubit/auth_cubit/auth_state.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/common_input_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/auth/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cnfPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ValueNotifier<bool> asASellerorUser = ValueNotifier(true);
  ValueNotifier<bool> agreeContinue = ValueNotifier(false);

  bool obscureText1 = true, obscureText2 = true;

  // userRegister(String phoneNumber, String name) {
  //   context.read<AuthCubit>().userRegister(phoneNumber, name);
  // }

  void handleUserButtonPress() {
    if (!asASellerorUser.value) {
      asASellerorUser.value = true;
    }
  }

  void handleSellerButtonPress() {
    if (asASellerorUser.value) {
      asASellerorUser.value = false;
    }
  }

  // void toggleUser() {
  //   asASellerorUser.value = !asASellerorUser.value;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, state) {
            if (state is AuthErrorState) {
              showCustomToast(context, state.errorMessage, true);
            }
            if (state is LoginRegisterSuccessState) {
              if (state.loginRegisterModel.success!) {
                showCustomToast(context,
                    state.loginRegisterModel.response!.message ?? "", false);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => Otp(
                      phoneNumber: phoneNumberController.text.toString().trim(),
                      roleId: asASellerorUser.value ? 0 : 1),
                ));
              } else {
                showCustomToast(
                    context, state.loginRegisterModel.errorMessage ?? "", true);
              }
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const Center(
                  child: SpinKitIndicator(
                type: SpinKitType.circle,
              ));
            }

            return SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(
                      height: 60,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          Images.signupVector,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          fit: BoxFit.contain,
                        )),
                    Text(
                      AppStrings.register.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: asASellerorUser,
                            builder: (BuildContext buildContext,
                                bool asASellerorUser, child) {
                              return InkWell(
                                onTap: () {
                                  handleUserButtonPress();
                                },
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: asASellerorUser
                                        ? AppColors.primary
                                        : AppColors.lightGary,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(
                                        30,
                                      ),
                                      bottomLeft: Radius.circular(
                                        30,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'As a User',
                                      style: TextStyle(
                                        color: asASellerorUser
                                            ? AppColors.white
                                            : AppColors.primary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: asASellerorUser,
                            builder: (BuildContext buildContext,
                                bool asASellerorUser, child) {
                              return InkWell(
                                onTap: () {
                                  handleSellerButtonPress();
                                },
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    color: asASellerorUser
                                        ? AppColors.lightGary
                                        : AppColors.primary,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(
                                        30,
                                      ),
                                      bottomRight: Radius.circular(
                                        30,
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'As a Seller',
                                      style: TextStyle(
                                          color: asASellerorUser
                                              ? AppColors.primary
                                              : AppColors.lightGary,
                                          fontSize: 14),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonInputBox(
                            controller: nameController,
                            hintText: AppStrings.name,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            overrideValidator: true,
                            validator: (p0) {
                              RegExp nameValidation =
                                  RegExp(r"^[a-zA-Z\s'-]+$");
                              if (p0 == null || nameController.text.isEmpty) {
                                return "This field is required";
                              } else if (!nameValidation.hasMatch(p0)) {
                                return "Enter correct name";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          CommonInputBox(
                            controller: phoneNumberController,
                            hintText: AppStrings.phoneNo,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            overrideValidator: true,
                            maxLength: 10,
                            validator: (val) {
                              if (val == null || val.isEmpty) {
                                return AppStrings.phoneNoErrorMsg;
                              } else if (val.length < 10) {
                                return AppStrings.phoneNoErrorMsg;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // CommonInputBox(
                          //   controller: emailController,
                          //   hintText: AppStrings.emailId,
                          //   keyboardType: TextInputType.emailAddress,
                          //   textInputAction: TextInputAction.next,
                          //   overrideValidator: true,
                          //   validator: (val) {
                          //     RegExp validateEmail =
                          //         RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          //     if (val == null || val.isEmpty) {
                          //       return 'Please enter email id';
                          //     } else if (!validateEmail.hasMatch(val)) {
                          //       return "Please enter correct email id";
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // CommonInputBox(
                          //   controller: passwordController,
                          //   hintText: 'Password',
                          //   keyboardType: TextInputType.name,
                          //   textInputAction: TextInputAction.next,
                          //   overrideValidator: true,
                          //   obscureText: obscureText1,
                          //   suffixIcon: InkWell(
                          //       onTap: () {
                          //         setState(() {
                          //           obscureText1 = !obscureText1;
                          //         });
                          //       },
                          //       child: Icon(obscureText1
                          //           ? Icons.visibility_off
                          //           : Icons.visibility)),
                          //   validator: (val) {
                          //     RegExp validatePassword = RegExp(
                          //         r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
                          //     if (val == null || val.isEmpty) {
                          //       return 'Please enter password';
                          //     } else if (!validatePassword.hasMatch(val)) {
                          //       return AppStrings.passwordRegexError;
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          // CommonInputBox(
                          //   controller: cnfPasswordController,
                          //   hintText: 'Confirm Password',
                          //   keyboardType: TextInputType.name,
                          //   textInputAction: TextInputAction.done,
                          //   overrideValidator: true,
                          //   obscureText: obscureText2,
                          //   suffixIcon: InkWell(
                          //       onTap: () {
                          //         setState(() {
                          //           obscureText2 = !obscureText2;
                          //         });
                          //       },
                          //       child: Icon(obscureText2
                          //           ? Icons.visibility_off
                          //           : Icons.visibility)),
                          //   validator: (val) {
                          //     RegExp validatePassword = RegExp(
                          //         r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");
                          //     if (val == null || val.isEmpty) {
                          //       return 'Please enter confirm password';
                          //     } else if (!validatePassword.hasMatch(val)) {
                          //       return AppStrings.passwordRegexError;
                          //     } else if (passwordController.text.toString() !=
                          //         cnfPasswordController.text.toString()) {
                          //       return "The password and confirm password do not match";
                          //     }
                          //     return null;
                          //   },
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Align(
                    //     alignment: Alignment.centerRight,
                    //     child: InkWell(
                    //         onTap: () async {
                    //           if (_formKey.currentState!.validate()) {
                    //             Map<String, dynamic> params =
                    //                 <String, dynamic>{};
                    //             params = {
                    //               "name": nameController.text.toString().trim(),
                    //               "phone": phoneNumberController.text
                    //                   .toString()
                    //                   .trim()
                    //             };
                    //             context.read<AuthCubit>().userRegister(
                    //                 phoneNumberController.text.trim(),
                    //                 nameController.text.trim());
                    //           }
                    //         },
                    //         child: Text(
                    //           AppStrings.sendOtp.toUpperCase(),
                    //           style: const TextStyle(
                    //               fontSize: 16,
                    //               fontFamily: Fonts.poppins,
                    //               fontWeight: FontWeight.bold,
                    //               color: AppColors.black),
                    //         ))),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Form(
                    //   key: _formKey1,
                    //   // autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       // CommonInputBox(
                    //       //   controller: otpController,
                    //       //   hintText: AppStrings.otp.toUpperCase(),
                    //       //   keyboardType: TextInputType.number,
                    //       //   textInputAction: TextInputAction.next,
                    //       //   maxLength: 4,
                    //       //   overrideValidator: true,
                    //       //   validator: (val) {
                    //       //     if (val == null || val.isEmpty) {
                    //       //       return AppStrings.otpError;
                    //       //     } else if (val.length < 4) {
                    //       //       return AppStrings.otpError;
                    //       //     } else {
                    //       //       agreeContinue.value = false;
                    //       //       agreeContinue.notifyListeners();
                    //       //     }
                    //       //     return null;
                    //       //   },
                    //       // ),

                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            );
          }),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0).copyWith(bottom: 3),
            //   child: RichText(
            //     textAlign: TextAlign.center,
            //     text: TextSpan(
            //       text: AppStrings.agreeContinueMsg,
            //       style: const TextStyle(color: AppColors.black),
            //       children: <TextSpan>[
            //         TextSpan(
            //             text: AppStrings.termsCondition,
            //             recognizer: TapGestureRecognizer()..onTap = () {},
            //             style: const TextStyle(
            //                 fontWeight: FontWeight.bold, color: Colors.blue)),
            //         const TextSpan(text: ' and'),
            //         TextSpan(
            //             text: AppStrings.privacyPolicy,
            //             recognizer: TapGestureRecognizer()..onTap = () {},
            //             style: const TextStyle(
            //                 fontWeight: FontWeight.bold, color: Colors.blue)),
            //       ],
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                  valueListenable: asASellerorUser,
                  builder:
                      (BuildContext buildContext, bool agreeContinue, child) {
                    return CommonButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Map<String, dynamic> params = <String, dynamic>{};
                          params = {
                            "roleId": asASellerorUser.value ? 0 : 1,
                            "name": nameController.text.toString().trim(),
                            "phone_no":
                                phoneNumberController.text.toString().trim(),
                            "otp": "789456",
                          };
                          print('params==>, $params');
                          context.read<AuthCubit>().userRegister(params);
                        }
                      },
                      buttonText: 'CONTINUE',
                      buttonColor: AppColors.primary,
                      buttonTextColor: AppColors.white,
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
