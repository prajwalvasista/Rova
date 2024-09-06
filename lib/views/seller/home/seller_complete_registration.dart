import 'dart:convert';
import 'dart:io';

import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/seller/seller_commercial_details_cubit/seller_commercial_details_cubit.dart';
import 'package:al_rova/cubit/seller/seller_commercial_details_cubit/seller_commercial_details_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/common_input_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:al_rova/views/seller/home/seller_home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';

class SellerCompleteRegistration extends StatefulWidget {
  static const String appRoute = '/gst_verification';
  const SellerCompleteRegistration({super.key});

  @override
  State<SellerCompleteRegistration> createState() =>
      _SellerCompleteRegistrationState();
}

class _SellerCompleteRegistrationState
    extends State<SellerCompleteRegistration> {
  int currentStep = 0;
  int selectedValue = 0;
  int selectedValue1 = 0;
  SizedBox defaultGap = const SizedBox(height: 15);
  String? imagePath, imageName = '';
  bool isPanCard = false;

  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  TextEditingController gstController = TextEditingController();
  TextEditingController pannoController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController areaStreetController = TextEditingController();
  TextEditingController phonenoController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  @override
  void initState() {
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    emailController.text = "";
    setState(() {});

    super.initState();
  }

  @override
  void dispose() {
    gstController.dispose();
    pannoController.dispose();
    storeNameController.dispose();
    pinCodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    areaStreetController.dispose();
    phonenoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  /// back pressed modal
  Future<bool> _onBackPressed() async {
    return (await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Incomplete Registration',
              style: headLine2.copyWith(fontSize: 20),
            ),
            content: const Text(
              'Are you sure want to exit the registration process?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SellerHome(),
                      ),
                      (r) => false);
                },
                child: const Text('Exit Anyway'),
              ),
            ],
          ),
        )) ??
        false; // Provide a default value of 'false' if null is returned
  }

  // choose image from gallary
  Future _getImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          imagePath = image.path;
          imageName = image.name;
        });
      }
    } catch (e) {
      print(e);
    }
  }

// take image from camera
  Future _getImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (image != null) {
        setState(() {
          imagePath = image.path;
          imageName = image.name;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
            onPressed: () {
              _onBackPressed();
              // Navigator.of(context).pop();
            },
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
              color: AppColors.white,
            )),
        title: Text(
          'Step ${currentStep + 1}',
          style: headLine2.copyWith(
            color: AppColors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SellerCommercialDetailsCubit,
          SellerCommercialDetailsState>(
        listener: (context, state) {
          if (state is SellerCommercialDetailsErrorState) {
            showCustomToast(
                context,
                '${state.errorMessage} one or more validation errors occured',
                true);
          }

          if (state is SellerCommercialDetailsSuccessState) {
            Navigator.of(context).pop();
            showCustomToast(
                context, state.addSellerCommercialDetailsModel.message!, false);
          }
        },
        builder: (context, state) {
          if (state is SellerCommercialDetailsLoadingState) {
            return const Center(
                child: SpinKitIndicator(
              type: SpinKitType.circle,
            ));
          }
          return Theme(
            data: ThemeData(
                primarySwatch: buildMaterialColor(AppColors.secondary),
                canvasColor: AppColors.primary,
                colorScheme: ColorScheme.light(
                    primary: buildMaterialColor(AppColors.secondary))),
            child: Stepper(
              steps: getSteps(),
              connectorThickness: 3,
              type: StepperType.horizontal,
              currentStep: currentStep,
              // connectorColor: const MaterialStatePropertyAll(Color(0xffD9D9D9)),
              onStepContinue: () {
                print('currentStep==>, $currentStep');
                final lastStep = currentStep == getSteps().length - 1;
                setState(() async {
                  if (lastStep) {
                    File file = File(imagePath!);
                    FormData params = FormData.fromMap({
                      "GST_Number": selectedValue == 0
                          ? gstController.text.toString().trim()
                          : "",
                      "PhoneNumber": phonenoController.text.toString().trim(),
                      "Email": emailController.text.toString().trim(),
                      "PAN_Number": pannoController.text.toString().trim(),
                      "PAN_Document": await MultipartFile.fromFile(
                        file.path,
                        filename: file.path.split("/").last,
                      ),
                      "StoreName": storeNameController.text.toString().trim(),
                      "City": cityController.text.toString().trim(),
                      "Pincode": pinCodeController.text.toString().trim(),
                      "State": stateController.text.toString().trim(),
                      "Area": areaStreetController.text.toString().trim(),
                      "ShippingPreference": selectedValue1 == 0 ? true : false,
                    });
                    context
                        .read<SellerCommercialDetailsCubit>()
                        .addSellerCommercialDetails(params);
                  } else {
                    if (_formKeys[currentStep].currentState!.validate()) {
                      setState(() {
                        currentStep++;
                      });
                    }
                  }
                });
              },
              onStepCancel: () {
                print('currentStep==>, $currentStep');
                setState(() {
                  currentStep--;
                });
              },
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        style: ButtonStyle(
                            backgroundColor: const WidgetStatePropertyAll(
                                AppColors.primary),
                            shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                    side:
                                        BorderSide(color: AppColors.primary)))),
                        onPressed: details.onStepContinue,
                        child: Text(
                          'Continue',
                          style: headLine2.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      currentStep != 0
                          ? TextButton(
                              onPressed: details.onStepCancel,
                              style: ButtonStyle(
                                  backgroundColor:
                                      const WidgetStatePropertyAll(
                                          AppColors.gary),
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                          side: BorderSide(
                                              color: AppColors.gary)))),
                              child: Text(
                                'Back',
                                style: headLine2.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Text(""),
          content: Form(
            key: _formKeys[0],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "GST Verification",
                  style: headLine2.copyWith(fontSize: 20),
                ),
                defaultGap,
                RadioListTile(
                  value: 0,
                  groupValue: selectedValue,
                  fillColor: const WidgetStatePropertyAll(AppColors.black),
                  title: const Text(
                    "I have a GST no.",
                    style: TextStyle(
                      color: AppColors.headingColor,
                    ),
                  ),
                  onChanged: ((value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  }),
                ),
                CommonInputBox(
                  controller: gstController,
                  hintText: 'GST No.',
                  overrideValidator: true,
                  validator: (value) {
                    if (selectedValue == 0) {
                      RegExp gstPattern = RegExp(
                          '^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}');
                      if (value == null || value.isEmpty) {
                        return "Please enter GST number";
                      } else if (!gstPattern.hasMatch(value)) {
                        return "Please enter correct GST number";
                      }
                    }
                    return null;
                  },
                ),
                RadioListTile(
                  value: 1,
                  groupValue: selectedValue,
                  fillColor: const WidgetStatePropertyAll(AppColors.black),
                  title: const Text(
                    "I don't have a GST no.",
                    style: TextStyle(
                      color: AppColors.headingColor,
                    ),
                  ),
                  onChanged: ((value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  }),
                ),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Text(""),
          content: Form(
            key: _formKeys[1],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "PAN No.",
                  style: headLine2.copyWith(fontSize: 20),
                ),
                defaultGap,
                const Text(
                  "Enter Your PAN No",
                  style: TextStyle(
                    color: AppColors.headingColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                defaultGap,
                CommonInputBox(
                  controller: pannoController,
                  hintText: 'PAN No.',
                  overrideValidator: true,
                  validator: (value) {
                    RegExp validatePan = RegExp(r'[A-Z]{5}[0-9]{4}[A-Z]{1}');
                    if (value == null || value.isEmpty) {
                      return "Enter Your PAN Number";
                    } else if (!validatePan.hasMatch(value)) {
                      return "Enter correct PAN Number";
                    } else {
                      return null;
                    }
                  },
                ),
                defaultGap,
                const Text(
                  "Upload PAN document",
                  style: TextStyle(
                    color: AppColors.headingColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SpeedDial(
                        icon: Icons.upload_file_rounded,
                        label: const Text('Upload'),
                        backgroundColor: AppColors.teftFieldBorderColor,
                        animationCurve: Curves.decelerate,
                        iconTheme: const IconThemeData(color: AppColors.white),
                        spacing: 15,
                        mini: false,
                        switchLabelPosition: true,
                        buttonSize: const Size(60, 50),
                        children: [
                          SpeedDialChild(
                            child: const Icon(
                              Icons.photo_library_rounded,
                              color: Colors.white,
                            ),
                            label: "Choose Photo",
                            backgroundColor: AppColors.primary,
                            onTap: () {
                              _getImageFromGallery();
                            },
                          ),
                          SpeedDialChild(
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                            ),
                            label: "Take Photo",
                            backgroundColor: AppColors.primary,
                            onTap: () {
                              _getImageFromCamera();
                            },
                          ),
                        ]),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(child: Text(imageName ?? "")),
                  ],
                ),
                defaultGap,
                isPanCard
                    ? Text(
                        'Please upload pan document*',
                        style: headLine4.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Text(""),
          content: Form(
            key: _formKeys[2],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Store Name",
                  style: headLine2.copyWith(fontSize: 20),
                ),
                defaultGap,
                const Text(
                  "Enter Your Store Name",
                  style: TextStyle(
                    color: AppColors.headingColor,
                  ),
                ),
                defaultGap,
                CommonInputBox(
                  controller: storeNameController,
                  hintText: 'Store Name',
                  overrideValidator: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your store name";
                    } else {
                      return null;
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 3,
          title: const Text(""),
          content: Form(
            key: _formKeys[3],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pickup Address",
                  style: headLine2.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 20),
                CommonInputBox(
                  controller: phonenoController,
                  hintText: 'Phone No',
                  overrideValidator: true,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone no";
                    } else if (value.length < 10) {
                      return "Please enter 10 digits phone no";
                    } else {
                      return null;
                    }
                  },
                ),
                defaultGap,
                const SizedBox(height: 10),
                CommonInputBox(
                  controller: emailController,
                  hintText: 'Email',
                  overrideValidator: true,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: false,
                  validator: (val) {
                    RegExp validateEmail =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (val == null || val.isEmpty) {
                      return 'Please enter email';
                    } else if (!validateEmail.hasMatch(val)) {
                      return "Please enter correct email id";
                    }
                    return null;
                  },
                ),
                defaultGap,
                const SizedBox(height: 10),
                CommonInputBox(
                  controller: pinCodeController,
                  hintText: 'Pin Code',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  overrideValidator: true,
                  validator: (value) {
                    RegExp pinCodeValidate = RegExp(r'^[1-9][0-9]{5}$');
                    if (value == null || value.isEmpty) {
                      return "Please enter pin code";
                    }
                    if (!pinCodeValidate.hasMatch(value)) {
                      return "Please enter correct pin code";
                    } else {
                      return null;
                    }
                  },
                ),
                defaultGap,
                const SizedBox(height: 10),
                CommonInputBox(
                  controller: cityController,
                  hintText: 'City',
                  textInputAction: TextInputAction.next,
                  overrideValidator: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter city name";
                    }
                    return null;
                  },
                ),
                defaultGap,
                const SizedBox(height: 10),
                CommonInputBox(
                  controller: stateController,
                  hintText: 'State',
                  textInputAction: TextInputAction.next,
                  overrideValidator: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter state name";
                    }
                    return null;
                  },
                ),
                defaultGap,
                const SizedBox(height: 10),
                CommonInputBox(
                  controller: areaStreetController,
                  hintText: 'Area, Street, Building No',
                  textInputAction: TextInputAction.done,
                  overrideValidator: true,
                  minLines: 3,
                  maxLines: 7,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter area, street, building no";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 4,
          title: const Text(""),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose Shipping Preferences",
                style: headLine2.copyWith(fontSize: 20),
              ),
              defaultGap,
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  child: RadioListTile(
                    fillColor: const WidgetStatePropertyAll(AppColors.black),
                    title: const Text(
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      "ROVA Shipping",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.headingColor,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text(
                      "ROVA team will take care of delivering products to the customers.",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.subtitleColor,
                      ),
                    ),
                    value: 0,
                    groupValue: selectedValue1,
                    onChanged: (value) {
                      setState(() {
                        selectedValue1 = value!;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: RadioListTile(
                    fillColor: const WidgetStatePropertyAll(AppColors.black),
                    title: const Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      "MY Shipping",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: AppColors.headingColor,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: const Text(
                      "Seller will be responsible for delivery of his products to the customers.",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.subtitleColor,
                      ),
                    ),
                    value: 1,
                    groupValue: selectedValue1,
                    onChanged: (value) {
                      setState(() {
                        selectedValue1 = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ];
}

MaterialColor buildMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
