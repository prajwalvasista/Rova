// import 'dart:async';
// import 'dart:convert';
// import 'package:al_rova/common/widget/empty_widget.dart';
// import 'package:al_rova/common/widget/spinkit_indicator.dart';
// import 'package:al_rova/cubit/customer/shop_store_cubit/shop_store_cubit.dart';
// import 'package:al_rova/cubit/customer/shop_store_cubit/shop_store_state.dart';
// import 'package:al_rova/utils/constants/colors.dart';
// import 'package:al_rova/utils/constants/fonts.dart';
// import 'package:al_rova/utils/constants/images.dart';
// import 'package:al_rova/utils/services/location_service.dart';
// import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// class ShopStoreListScreen extends StatefulWidget {
//   const ShopStoreListScreen({
//     super.key,
//   });

//   @override
//   State<ShopStoreListScreen> createState() => _ShopStoreListScreenState();
// }

// class _ShopStoreListScreenState extends State<ShopStoreListScreen> {
//   bool servicestatus = false, haspermission = false, isLocationEnabled = false;
//   late LocationPermission permission;
//   late Position position;
//   String long = "",
//       lat = "",
//       dayName = "",
//       tempImg = "",
//       location = "",
//       weatherTitle = "",
//       weatherDescription = "",
//       country = "";
//   late StreamSubscription<Position> positionStream;

//   String cityName = "";
//   @override
//   void initState() {
//     super.initState();
//     checkGps();
//     checkLocationStatus();
//   }

//   // check location in enable or not
//   Future<void> checkLocationStatus() async {
//     bool locationEnabled = await LocationService.isLocationEnabled();

//     setState(() {
//       isLocationEnabled = locationEnabled;
//     });
//     print('locationEnabled===> $locationEnabled');
//   }

//   // check location permission
//   checkGps() async {
//     servicestatus = await Geolocator.isLocationServiceEnabled();
//     if (servicestatus) {
//       permission = await Geolocator.checkPermission();

//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           print('Location permissions are denied');
//         } else if (permission == LocationPermission.deniedForever) {
//           print("'Location permissions are permanently denied");
//         } else {
//           haspermission = true;
//         }
//       } else {
//         haspermission = true;
//       }

//       if (haspermission) {
//         setState(() {
//           //refresh the UI
//         });
//         getLocation();
//       }
//     } else {
//       print("GPS Service is not enabled, turn on GPS location");
//     }

//     setState(() {
//       //refresh the UI
//     });
//   }

//   // get current location
//   getLocation() async {
//     position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//     print(position.longitude); //Output: 80.24599079
//     print(position.latitude); //Output: 29.6593457

//     long = position.longitude.toString();
//     lat = position.latitude.toString();

//     setState(() {
//       //refresh UI
//     });

//     LocationSettings locationSettings = const LocationSettings(
//       accuracy: LocationAccuracy.high, //accuracy of the location data
//       distanceFilter: 100, //minimum distance (measured in meters) a
//       //device must move horizontally before an update event is generated;
//     );

//     StreamSubscription<Position> positionStream =
//         Geolocator.getPositionStream(locationSettings: locationSettings)
//             .listen((Position position) {
//       print(position.longitude); //Output: 80.24599079
//       print(position.latitude); //Output: 29.6593457

//       long = position.longitude.toString();
//       lat = position.latitude.toString();

//       // getAddress(position);
//       setState(() {
//         //refresh UI on update
//       });
//     });
//     getCityName(position);
//   }

// // reverse address by lat and long
//   getCityName(Position position) async {
//     final response = await http.get(
//       Uri.parse(
//           'https://us1.locationiq.com/v1/reverse?key=pk.23220a420c3dce27cc1f1e59b4427a95&lat=${position.latitude}&lon=${position.longitude}&format=json'),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//     );
//     final resData = json.decode(response.body);
//     cityName = resData['address']['city'] ?? "Dehradun";
//     print('resdata==> $resData');
//     if (resData['address']['city'].toString().isNotEmpty) {
//       getShopData(resData['address']['city'].toString());
//     }
//   }

//   getShopData(String city) async {
//     if (!mounted) return;
//     context.read<ShopStoreCubit>().fetchShopStore("Tumkur");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade300,
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 5,
//         backgroundColor: Colors.white,
//         title: const Text(
//           "Nearby Store",
//           style: TextStyle(fontSize: 22),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 checkGps();
//               },
//               icon: const Icon(Icons.refresh))
//         ],
//       ),
//       body: BlocConsumer<ShopStoreCubit, ShopStoreState>(
//           listener: (context, state) {},
//           builder: (context, state) {
//             if (state is ShopStoreSuccess && state.storeShopList.isEmpty) {
//               return const EmptyWidget(
//                   message: "No Store Found. Please check with other location.");
//             }
//             if (state is ShopStoreLoding) {
//               return const SpinKitIndicator(
//                 type: SpinKitType.circle,
//               );
//             }
//             if (state is ShopStoreError) {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 showCustomToast(context, state.message, true);
//               });
//             }
//             if (state is ShopStoreSuccess) {
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 child: Container(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   child: ListView.builder(
//                     padding: EdgeInsets.zero,
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return Column(
//                         children: [
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Card(
//                             margin: EdgeInsets.zero,
//                             //  color: Colors.transparent,
//                             child: Container(
//                               decoration: const BoxDecoration(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20))),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 mainAxisSize: MainAxisSize.max,
//                                 children: [
//                                   Expanded(
//                                     flex: 2,
//                                     child: Image.asset(
//                                       Images.shopStoreImage,
//                                       //   fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 5,
//                                     child: Container(
//                                       decoration: const BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius: BorderRadius.only(
//                                               bottomRight: Radius.circular(20),
//                                               topRight: Radius.circular(20)
//                                               //Radius.circular(0)
//                                               )),
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10),
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.max,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Text(
//                                             state.storeShopList[index]
//                                                     .shopName ??
//                                                 "",
//                                             style: const TextStyle(
//                                               fontFamily:
//                                                   Fonts.robotoSlabSemiBold,
//                                               fontWeight: FontWeight.w800,
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           ),
//                                           Text(
//                                             state.storeShopList[index]
//                                                     .shopAddress ??
//                                                 "",
//                                             style: const TextStyle(
//                                                 fontFamily:
//                                                     Fonts.robotoSlabRegular,
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize: 11,
//                                                 color: AppColors.greyTextColor),
//                                           ),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             children: [
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   if (state
//                                                       .storeShopList[index]
//                                                       .contactNumber!
//                                                       .isNotEmpty) {
//                                                     var url = Uri.parse(
//                                                         'tel://${state.storeShopList[index].contactNumber}');
//                                                     await launchUrl(url);
//                                                   } else {
//                                                     showCustomToast(
//                                                         context,
//                                                         'Shop contact number is not available.',
//                                                         true);
//                                                   }
//                                                 },
//                                                 child: Image.asset(
//                                                   Images.callIcon,
//                                                   height: 23,
//                                                   width: 23,
//                                                 ),
//                                               ),
//                                               const SizedBox(
//                                                 width: 15,
//                                               ),
//                                               GestureDetector(
//                                                 onTap: () async {
//                                                   if (state
//                                                       .storeShopList[index]
//                                                       .locationUrl!
//                                                       .isNotEmpty) {
//                                                     var url = Uri.parse(
//                                                         '${state.storeShopList[index].locationUrl}');
//                                                     await launchUrl(url);
//                                                   } else {
//                                                     showCustomToast(
//                                                         context,
//                                                         'Shop location url is not available.',
//                                                         true);
//                                                   }
//                                                 },
//                                                 child: Image.asset(
//                                                   Images.mapIcon,
//                                                   height: 25,
//                                                   width: 25,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           const SizedBox(
//                                             height: 5,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                     itemCount: state.storeShopList.length ?? 0,
//                   ),
//                 ),
//               );
//             }
//             return const SizedBox();
//           }),
//       // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     Navigator.of(context).push(MaterialPageRoute(
//       //       builder: (context) => const AddNewShop(),
//       //     ));
//       //   },
//       //   backgroundColor: AppColors.primary,
//       //   foregroundColor: AppColors.primary,
//       //   child: const Icon(
//       //     Icons.add,
//       //     size: 35,
//       //     color: AppColors.white,
//       //   ),
//       // ),
//     );
//   }
// }
