import 'dart:convert';

import 'package:al_rova/common/cubit/user_authentication_cubit.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/services/route_constant.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
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

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: false, max: 1);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    );
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isUserLoggedIn();
      }
    });

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  isUserLoggedIn() async {
    final userAuthCubit = context.read<UserAuthCubit>();
    final isUserAuthenticated = await userAuthCubit.isAuthenticatedUser();
    if (isUserAuthenticated) {
      List splitValues = userModel!.response!.roleId!.split('');
      if (splitValues[2] == 'C') {
        Navigator.pushNamed(context, AppRoutes.customerHome);
      } else if (splitValues[2] == 'S') {
        Navigator.pushNamed(context, AppRoutes.sellerHome);
      } else {
        showCustomToast(context, 'Role id not valid', true);
      }
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(Images.splashBg),
              fit: BoxFit.cover,
              opacity: 0.15),
        ),
        child: Center(
            child: SizeTransition(
          sizeFactor: _animation,
          axis: Axis.horizontal,
          axisAlignment: -1,
          child: Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 2 - 40),
            child: Image.asset(
              Images.splashLogo,
              fit: BoxFit.contain,
            ),
          ),
        )),
      ),
    );
  }
}
