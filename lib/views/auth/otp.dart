
import 'package:al_rova/common/cubit/user_authentication_cubit.dart';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/auth_cubit/auth_cubit.dart';
import 'package:al_rova/cubit/auth_cubit/auth_state.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_cubit.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/customer/home/customer_home.dart';
import 'package:al_rova/views/seller/home/seller_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Otp extends StatefulWidget {
  String phoneNumber;
  int roleId;
  Otp({super.key, required this.phoneNumber, required this.roleId});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool hasError = false;
  String currentText = "";
  final _formKey = GlobalKey<FormState>();
  // StreamController<ErrorAnimationType>? errorController;

  // final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // int _resendCountdown = 300; // Initial countdown value in seconds
  // bool _isCountdownActive = true;
  // late Timer _countdownTimer;

  @override
  void initState() {
    // startResendCountdown();
    // errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    // _countdownTimer.cancel();
    textEditingController.dispose();
    focusNode.dispose();
    // errorController!.close();
    super.dispose();
  }

  // void startResendCountdown() {
  //   _isCountdownActive = true;
  //   _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     setState(() {
  //       if (_resendCountdown > 0) {
  //         _resendCountdown--;
  //       } else {
  //         setState(() {
  //           _isCountdownActive = false;
  //         });
  //         _countdownTimer.cancel();
  //       }
  //     });
  //   });
  // }

  // void handleResend() {
  //   // Add logic here to resend OTP
  //   // For now, we'll just restart the countdown
  //   if (!_isCountdownActive) {
  //     _resendCountdown = 300;
  //     startResendCountdown();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        foregroundColor: AppColors.black,
        backgroundColor: AppColors.white,
      ),
      // key: _scaffoldKey,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            showCustomToast(context, state.errorMessage ?? "", true);
          }
          if (state is AuthOtpSuccessState) {
            print("token ${state.verifyOtpnModel.response?.token ?? ""}");

            List splitValues =
                state.verifyOtpnModel.response!.roleId!.split('');
            print('splitValues==> $splitValues');
            context.read<UserAuthCubit>().checkUserAuthentication();
            if (splitValues[2] == 'C') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomerHome()));
            } else if (splitValues[2] == 'S') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider(
                        create: (context) =>
                            ProductCubit(productRepository: getIt()),
                        child: const SellerHome(),
                      )));
            }

            showCustomToast(context, "Register successfully", false);
          }
        },
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Center(
                child: SpinKitIndicator(
              type: SpinKitType.circle,
            ));
          }
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              // height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,
              color: AppColors.white,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          Images.otpVector,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 3,
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.verifyOtp.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontFamily: Fonts.poppins,
                              letterSpacing: 0.4,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 15,
                          ),
                          child: PinCodeTextField(
                            autoDisposeControllers: false,
                            appContext: context,
                            pastedTextStyle: const TextStyle(
                              color: AppColors.lightGary,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 6,
                            obscureText: false,
                            obscuringCharacter: '*',
                            // errorAnimationController: errorController,
                            // obscuringWidget: const FlutterLogo(
                            //   size: 24,
                            // ),
                            blinkWhenObscuring: true,
                            animationType: AnimationType.fade,
                            validator: (v) {
                              if (v!.length < 5) {
                                return "Please Enter 6 digits pin.";
                              } else {
                                return null;
                              }
                            },
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(8),
                                borderWidth: 1.5,
                                activeColor: AppColors.primary,
                                inactiveColor: AppColors.lightGary,
                                fieldHeight: 50,
                                fieldWidth: 46,
                                activeFillColor: Colors.white,
                                inactiveFillColor: AppColors.lightGary),
                            cursorColor: Colors.black,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            enableActiveFill: false,
                            controller: textEditingController,
                            focusNode: focusNode,
                            keyboardType: TextInputType.number,
                            boxShadows: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            onCompleted: (v) {
                              debugPrint("Completed");
                            },

                            onChanged: (value) {
                              debugPrint(value);
                              setState(() {
                                currentText = value;
                              });
                            },
                            beforeTextPaste: (text) {
                              debugPrint("Allowing to paste $text");

                              return true;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 0,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     const Text(
                    //       AppStrings.donntReceiveCode,
                    //       style: TextStyle(
                    //           color: Colors.black54,
                    //           fontSize: 15,
                    //           fontFamily: Fonts.poppins),
                    //     ),
                    //     if (!_isCountdownActive)
                    //       TextButton(
                    //         onPressed: () {
                    //           handleResend();
                    //         },
                    //         child: const Text(
                    //           AppStrings.resend,
                    //           style: TextStyle(
                    //               color: AppColors.primary,
                    //               fontSize: 16,
                    //               fontWeight: FontWeight.w800,
                    //               fontFamily: Fonts.poppins,
                    //               decoration: TextDecoration.underline,
                    //               decorationColor: AppColors.primary),
                    //         ),
                    //       ),
                    //     if (_resendCountdown != 0)
                    //       Padding(
                    //         padding: const EdgeInsets.only(left: 5),
                    //         child: Text(
                    //           '$_resendCountdown s',
                    //           style: const TextStyle(color: Colors.black),
                    //         ),
                    //       )
                    //   ],
                    // ),
                    const SizedBox(
                      height: 14,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonButton(
                height: 50.0,
                width: MediaQuery.of(context).size.width,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (currentText.length != 6) {
                    } else {
                      Map<String, dynamic> params = {
                        "phoneNumber": widget.phoneNumber,
                        "otp": currentText,
                        "roleid": widget.roleId
                      };
                      context.read<AuthCubit>().verifyOtp(params);
                    }
                  }
                },
                buttonText: AppStrings.verify.toUpperCase(),
                buttonColor: AppColors.primary,
                buttonTextColor: AppColors.white),
          )),
    );
  }
}
