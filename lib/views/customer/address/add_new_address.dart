import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/address_cubit/address_cubit.dart';
import 'package:al_rova/cubit/customer/address_cubit/address_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/models/customer/address/address_response_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/services/location_service.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/common_input_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class AddNewAddress extends StatefulWidget {
  bool isEdit;
  AddressResponseModel? data;
  AddNewAddress({super.key, required this.isEdit, this.data});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  bool servicestatus = false, haspermission = false, isLocationEnabled = false;
  late LocationPermission permission;
  late Position position;
  late StreamSubscription<Position> positionStream;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController altPhoneController = TextEditingController();
  TextEditingController countryController =
      TextEditingController(text: "India");
  TextEditingController housenoController = TextEditingController();
  TextEditingController roadnameController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  bool isHome = true,
      isWork = false,
      isSunday = false,
      isSaturday = false,
      isDefault = false,
      isLoading = false;
  String long = "", lat = "";

  @override
  void initState() {
    super.initState();

    checkLocationStatus();
    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    nameController.text = widget.data?.name ?? "";
    phoneController.text = widget.data?.phoneNumber ?? "";
    altPhoneController.text = widget.data?.alternatePhoneNumber ?? "";
    countryController.text = widget.data?.country ?? "";
    stateController.text = widget.data?.state ?? "";
    cityController.text = widget.data?.city ?? "";
    pincodeController.text = widget.data?.zipcode ?? "";
    housenoController.text = widget.data?.buildingName ?? "";
    roadnameController.text = widget.data?.areaColony ?? "";
    isHome = widget.isEdit
        ? widget.data?.saveAddressAs == 1
            ? true
            : false
        : true;
    isWork = widget.data?.saveAddressAs == 2 ? true : false;
    isDefault = widget.data?.makeAsDefaultAddress ?? false;
    isSaturday = widget.data?.opensOnSaturday ?? false;
    isSunday = widget.data?.opensOnSunday ?? false;
  }

// toggle home function
  void toggleHome() {
    setState(() {
      isHome = true;
      isWork = false;

      isSaturday = false;
      isSunday = false;
    });
  }

// toggle work function
  void toggleWork() {
    setState(() {
      isWork = true;
      isHome = false;
    });
  }

  // check location in enable or not
  Future<void> checkLocationStatus() async {
    bool locationEnabled = await LocationService.isLocationEnabled();

    setState(() {
      isLocationEnabled = locationEnabled;
    });
    print('locationEnabled===> $locationEnabled');
  }

  // check location permission
  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });
        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    // setState(() {
    //   //refresh the UI
    // });
  }

  // get current location
  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    // setState(() {
    //   //refresh UI
    // });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      // getAddress(position);
      // setState(() {
      //   //refresh UI on update
      // });
    });
    getCityName(position);
  }

  // reverse address by lat and long
  getCityName(Position position) async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get(
      Uri.parse(
          'https://us1.locationiq.com/v1/reverse?key=pk.23220a420c3dce27cc1f1e59b4427a95&lat=${position.latitude}&lon=${position.longitude}&format=json'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    final resData = json.decode(response.body);
    cityController.text = resData['address']['city'] ?? "Dehradun";
    countryController.text = resData['address']['country'] ?? "India";
    stateController.text = resData['address']['state'] ?? "India";
    pincodeController.text = resData['address']['postcode'] ?? "India";
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    altPhoneController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    housenoController.dispose();
    roadnameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.primary,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Platform.isAndroid
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_back_ios_new_rounded,
              color: const Color.fromRGBO(255, 255, 255, 1),
            )),
        title: Text(
          widget.isEdit ? 'Edit Address' : 'Add New Address',
          style: headLine2.copyWith(color: AppColors.white, fontSize: 20),
        ),
      ),
      backgroundColor: AppColors.white,
      body: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is SuccessState) {
            Navigator.of(context).pop();
            showCustomToast(context, state.successResponse.message!, false);
          }
        },
        builder: (context, state) {
          if (state is AddressLoadingState) {
            return const Center(
              child: SpinKitIndicator(
                type: SpinKitType.circle,
              ),
            );
          }
          return Stack(
            children: [
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                        backgroundColor: Colors.transparent,
                      ),
                    )
                  : const SizedBox(),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formkey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        CommonInputBox(
                          controller: nameController,
                          hintText: 'Full Name*',
                          textInputAction: TextInputAction.next,
                          overrideValidator: true,
                          validator: (p0) {
                            RegExp nameValidation = RegExp(r'^[a-zA-Z]+$');
                            if (p0 == null || nameController.text.isEmpty) {
                              return 'Please enter name';
                            } else if (!nameValidation.hasMatch(p0)) {
                              return 'Name should contains only alphabet';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CommonInputBox(
                          controller: phoneController,
                          hintText: 'Phone Number*',
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.phone,
                          overrideValidator: true,
                          validator: (p0) {
                            RegExp phoneValidation = RegExp(r"^[0-9]{10}$");
                            if (p0 == null || phoneController.text.isEmpty) {
                              return 'Enter phonenumber';
                            } else if (!phoneValidation.hasMatch(p0)) {
                              return "Not valid phone number";
                            } else {
                              return null;
                            }
                          },
                          maxLength: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CommonInputBox(
                          controller: altPhoneController,
                          hintText: 'Alternate Phone Number',
                          textInputAction: TextInputAction.done,
                          overrideValidator: true,
                          maxLength: 10,
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  checkGps();
                                  isLoading = true;
                                });
                              },
                              style: const ButtonStyle(
                                backgroundColor:
                                    WidgetStatePropertyAll(Color(0xff50623A)),
                                iconColor:
                                    WidgetStatePropertyAll(AppColors.white),
                              ),
                              icon: const Icon(Icons.my_location_outlined),
                              label: Text(
                                'Use current location',
                                style:
                                    headLine3.copyWith(color: AppColors.white),
                              )),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 15,
                              child: CommonInputBox(
                                controller: countryController,
                                hintText: 'Country*',
                                readOnly: false,
                                validator: (p0) {
                                  RegExp countryValidation =
                                      RegExp(r'^[a-zA-ZÀ-ÖØ-öø-ÿ \-]+$');
                                  if (p0 == null ||
                                      countryController.text.isEmpty) {
                                    return 'Enter country name';
                                  } else if (!countryValidation.hasMatch(p0)) {
                                    return "Country name is invalid";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 15,
                              child: CommonInputBox(
                                controller: stateController,
                                hintText: 'State*',
                                textInputAction: TextInputAction.next,
                                validator: (p0) {
                                  RegExp stateValidation =
                                      RegExp(r'^[a-zA-ZÀ-ÖØ-öø-ÿ \-]+$');
                                  if (p0 == null ||
                                      stateController.text.isEmpty) {
                                    return "Enter State";
                                  } else if (!stateValidation.hasMatch(p0)) {
                                    return 'State name is invalid';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 15,
                              child: CommonInputBox(
                                controller: cityController,
                                hintText: 'City/District*',
                                textInputAction: TextInputAction.next,
                                validator: (p0) {
                                  RegExp cityValidation =
                                      RegExp(r'^[a-zA-ZÀ-ÖØ-öø-ÿ \-]+$');
                                  if (p0 == null ||
                                      cityController.text.isEmpty) {
                                    return "Enter city name";
                                  } else if (!cityValidation.hasMatch(p0)) {
                                    return "city name is invalid";
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2 - 15,
                              child: CommonInputBox(
                                controller: pincodeController,
                                hintText: 'Pin Code*',
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.done,
                                overrideValidator: true,
                                validator: (val) {
                                  RegExp pinValidation = RegExp(r'^\d{6}$');
                                  if (val == null || val.isEmpty) {
                                    return 'Enter Pin';
                                  } else if (!pinValidation.hasMatch(val)) {
                                    return 'Enter correct Pin code';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CommonInputBox(
                          controller: housenoController,
                          hintText: 'House No. / Building name*',
                          validator: (p0) {
                            RegExp houseValidation =
                                RegExp(r'^[a-zA-Z0-9\s]+$');
                            if (p0 == null || housenoController.text.isEmpty) {
                              return "Enter house number";
                            } else if (!houseValidation.hasMatch(p0)) {
                              return "Enter correct house number";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CommonInputBox(
                          controller: roadnameController,
                          hintText: 'Road name , Area colony*',
                          validator: (p0) {
                            RegExp roadNameValidation =
                                RegExp(r'^[a-zA-Z0-9\s\-\.\,]+$');
                            if (p0 == null || roadnameController.text.isEmpty) {
                              return "Enter RoadName";
                            } else if (!roadNameValidation.hasMatch(p0)) {
                              return "Enter correct road name";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Save Address As',
                          style: headLine2.copyWith(),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                toggleHome();
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isHome
                                            ? AppColors.primary
                                            : AppColors.lightGary,
                                        width: isHome ? 2 : 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Home',
                                  style: headLine6.copyWith(fontSize: 15.5),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                toggleWork();
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: isWork
                                            ? AppColors.primary
                                            : AppColors.lightGary,
                                        width: isWork ? 2 : 1.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Work',
                                  style: headLine6.copyWith(fontSize: 15.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isWork
                            ? Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CheckboxListTile(
                                      value: isSaturday,
                                      activeColor: AppColors.primary,
                                      contentPadding: const EdgeInsets.only(
                                          top: 0, left: 20),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        'Open on Saturday',
                                        style: headLine3.copyWith(
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isSaturday = value!;
                                        });
                                      },
                                    ),
                                    CheckboxListTile(
                                      value: isSunday,
                                      activeColor: AppColors.primary,
                                      contentPadding: const EdgeInsets.only(
                                          top: 0, left: 20),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(
                                        'Open on Sunday',
                                        style: headLine3.copyWith(
                                            fontWeight: FontWeight.w400),
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isSunday = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(
                                height: 20,
                              ),
                        CheckboxListTile(
                          value: isDefault,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.primary,
                          title: Text(
                            'Make as default address',
                            style:
                                headLine3.copyWith(fontWeight: FontWeight.w400),
                          ),
                          onChanged: (value) {
                            setState(() {
                              isDefault = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CommonButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              // Map<String, dynamic> params = <String, dynamic>{};
              FormData params = FormData.fromMap({
                "CustomerId": userModel!.response!.roleId!,
                "Name": nameController.text.toString().trim(),
                "PhoneNumber": phoneController.text.toString().trim(),
                "AlternatePhoneNumber":
                    altPhoneController.text.toString().trim(),
                "BuildingName": housenoController.text.toString().trim(),
                "AreaColony": roadnameController.text.toString().trim(),
                "City": cityController.text.toString().trim(),
                "State": stateController.text.toString().trim(),
                "Country": countryController.text.toString().trim(),
                "Zipcode": pincodeController.text.trim(),
                "SaveAddressAs": isHome ? 1 : 2,
                "OpensOnSaturday": isSaturday,
                "OpensOnSunday": isSunday,
                "MakeAsDefaultAddress": isDefault,
              });
              widget.isEdit
                  ? context
                      .read<AddressCubit>()
                      .editAddress(widget.data!.addressId!, params)
                  : context.read<AddressCubit>().addAddress(params);
            } else {
              print('object false');
            }
          },
          buttonText: 'Save Address',
          buttonColor: AppColors.primary,
          buttonTextColor: AppColors.white,
          width: MediaQuery.of(context).size.width,
          height: 50,
          fontSize: 16,
        ),
      ),
    );
  }
}
