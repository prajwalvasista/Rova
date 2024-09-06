import 'dart:async';
import 'dart:io';
import 'package:al_rova/common/cubit/user_authentication_cubit.dart';
import 'package:al_rova/cubit/auth_cubit/auth_cubit.dart';
import 'package:al_rova/cubit/auth_cubit/auth_state.dart';
import 'package:al_rova/cubit/customer/crop_cubit/crop_cubit.dart';
import 'package:al_rova/cubit/customer/crop_cubit/crop_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/strings.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/services/route_constant.dart';
import 'package:al_rova/utils/widgets/speed_dial.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/customer/ecommerce/ecommerce_home.dart';
import 'package:al_rova/views/customer/crop/crop_result.dart';
import 'package:al_rova/views/customer/my_order/my_orders.dart';
import 'package:al_rova/views/customer/profile/my_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int _currentIndex = 0;

  final pages = [
    const EcommerceHome(),
    const MyOrders(),
    const MyProfile()
  ];

  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();
  String? imagePath;

  // bool isLoading = false;
  ValueNotifier<bool> isLoading = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    showCropDialog();
  }

  Future<void> showCropDialog() async {
    var prefs = await SharedPreferences.getInstance();
    bool? dontAgainShow = prefs.getBool('dontAgainShow');
    // Show the popup when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dontAgainShow ?? _showCheckboxPopup(context);
    });
  }

  // about tomato crop msg modal
  void _showCheckboxPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
              "Our app is currently optimized for tomato crop. Stay tuned for future updates and additional crop support."),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.setBool('dontAgainShow', true);
                Navigator.pop(context);
              },
              child: const Text("Don't show again"),
            ),
          ],
        );
      },
    );
  }

// choose image from gallary
  Future _getImageFromGallery() async {
    // setState(() {
    isLoading.value = true;
    isLoading.notifyListeners();
    // });
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 320,
        maxHeight: 320,
      );
      var imgName = image?.name;
      var splitImgName = imgName?.split('.');
      var getImgExtName = splitImgName![1];

      if (getImgExtName != 'png') {
        if (image != null) {
          imagePath = image.path;
          // String imagePath = image.path;
          // isLoading.value = false;
          // isLoading.notifyListeners();
          context.read<CropCubit>().fetchCropDiseaseName(imagePath!);
        } else {
          // setState(() {
          //   isLoading = false;
          // });
          isLoading.value = false;
          isLoading.notifyListeners();
        }
      } else {
        // setState(() {
        isLoading.value = false;
        isLoading.notifyListeners();
        // });
        _showDialog('Currently png file is not supported');
      }
    } catch (e) {
      // setState(() {
      isLoading.value = false;
      isLoading.notifyListeners();
      // });
      _showDialog('Something went wrong.');
    }
  }

// take image from camera
  Future _getImageFromCamera() async {
    // setState(() {
    isLoading.value = true;
    isLoading.notifyListeners();
    // });
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
        maxWidth: 320,
        maxHeight: 320,
      );
      var imgName = image?.name;
      var splitImgName = imgName?.split('.');
      var getImgExtName = splitImgName![1];

      if (getImgExtName != 'png') {
        if (image != null) {
          imagePath = image.path;
          // isLoading.value = false;
          // isLoading.notifyListeners();
          context.read<CropCubit>().fetchCropDiseaseName(imagePath!);
        } else {
          // setState(() {
          isLoading.value = false;
          isLoading.notifyListeners();
          // });
        }
      } else {
        // setState(() {
        isLoading.value = false;
        isLoading.notifyListeners();

        // });
        _showDialog('Currently png file is not supported');
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      // });

      isLoading.value = false;
      isLoading.notifyListeners();

      _showDialog('Something went wrong.');
    }
  }

// show erroe dialog box
  void _showDialog(String message) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // title: const Text('Crop '),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) {
            return;
          }
          _onBackPressed();
        },
        child: Scaffold(
          appBar: null,
          body: BlocListener<UserAuthCubit, UserAuthState>(
            listener: (context, state) {
              if (state is UserAuthLoggedOutState) {
                showCustomToast(context, state.message ?? "", false);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.login, (Route<dynamic> route) => false);
              }
            },
            child: Center(
              child: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthDeleteAccount) {
                    localStorage.logout();
                    showCustomToast(context,
                        state.deleteAccountModel.resultMessage ?? "", false);
                    // setState(() {
                    isLoading.value = true;
                    isLoading.notifyListeners();
                    // });
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        AppRoutes.login, (Route<dynamic> route) => false);
                  }
                },
                child: BlocConsumer<CropCubit, CropState>(
                  listener: (context, state) {
                    if (state is ObjectDetectionState) {
                      isLoading.value = false;
                      isLoading.notifyListeners();
                      _showDialog(state.objectDetectionModel.message ?? "");
                    }
                    if (state is CropSuccessState) {
                      isLoading.value = false;
                      isLoading.notifyListeners();
                      if (state.cropDiseaseModel.accuracy! > 80) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropResult(
                                modelName: state.cropDiseaseModel.type!,
                                image: imagePath ?? ""),
                          ),
                        );
                      } else {
                        _showDialog(AppStrings.cropResultErrorMsg);
                      }
                    }
                  },
                  builder: (context, state) {
                    return Stack(children: [
                      Container(child: pages[_currentIndex]),
                      ValueListenableBuilder(
                          valueListenable: isLoading,
                          builder: (BuildContext buildContext, bool isLoading,
                              child) {
                            return isLoading
                                ? Container(
                                    color: Colors.black.withOpacity(0.7),
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.white,
                                      ),
                                    ),
                                  )
                                : const SizedBox();
                          }),
                    ]);
                  },
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white,
            elevation: 7,
            selectedItemColor: AppColors.primary,
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_rounded),
                label: 'My Order',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
          floatingActionButton: _currentIndex == 0
              ? SpeedDialBtn(
                  onChooseImgClick: () async {
                    await _getImageFromGallery();
                  },
                  onTakePhotoClick: () async {
                    await _getImageFromCamera();
                  },
                )
              : const SizedBox(),
        ));
  }

  /// back pressed modal
  Future<bool> _onBackPressed() async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  print("Yes pressed");
                  exit(0);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false; // Provide a default value of 'false' if null is returned
  }
}
