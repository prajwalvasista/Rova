import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/auth_cubit/auth_cubit.dart';
import 'package:al_rova/cubit/auth_cubit/auth_state.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/services/route_constant.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/common_input_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/auth/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  ValueNotifier<bool> asASellerorUser = ValueNotifier(true);

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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AuthErrorState) {
            showCustomToast(context, state.errorMessage ?? "", true);
          }
          if (state is LoginRegisterSuccessState) {
            if (state.loginRegisterModel.success!) {
              showCustomToast(context,
                  state.loginRegisterModel.response!.message ?? "", false);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Otp(
                    phoneNumber: phoneController.text.toString().trim(),
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
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        Images.loginVector,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        fit: BoxFit.contain,
                      )),
                  const SizedBox(height: 30),
                  const Text(
                    AppStrings.signIn,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                                            : AppColors.primary),
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
                    height: 30,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Form(
                      key: _formKey,
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          CommonInputBox(
                            controller: phoneController,
                            hintText: AppStrings.phoneNo,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            maxLength: 10,
                            overrideValidator: true,
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
                          //   controller: passwordController,
                          //   hintText: 'Password',
                          //   keyboardType: TextInputType.visiblePassword,
                          //   overrideValidator: true,
                          //   textInputAction: TextInputAction.done,
                          //   obscureText: obscureText,
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
                          //   suffixIcon: InkWell(
                          //       onTap: () {
                          //         setState(() {
                          //           obscureText = !obscureText;
                          //         });
                          //       },
                          //       child: Icon(obscureText
                          //           ? Icons.visibility_off
                          //           : Icons.visibility)),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CommonButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Map<String, dynamic> params = <String, dynamic>{};
                        params = {
                          "roleType": asASellerorUser.value ? 0 : 1,
                          "phone_no": phoneController.text.toString().trim(),
                        };
                        context.read<AuthCubit>().userLogin(params);
                      }
                    },
                    buttonText: AppStrings.signIn,
                    buttonColor: AppColors.primary,
                    buttonTextColor: AppColors.white,
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        AppStrings.dontHaveAnAccount,
                        style: TextStyle(
                          color: Color(0xFF07243C),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.register);
                        },
                        child: const Text(
                          AppStrings.registerHere,
                          style: TextStyle(
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
