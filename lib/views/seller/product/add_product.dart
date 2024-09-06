import 'dart:convert';
import 'dart:io';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_cubit.dart';
import 'package:al_rova/cubit/seller/product_cubit/product_state.dart';
import 'package:al_rova/di.dart';
import 'package:al_rova/models/auth/verify_otp_model.dart';
import 'package:al_rova/models/seller/product/get_all_product_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/services/local_storage.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/common_input_box.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  bool isEdit;
  GetAllProductModel? data;
  AddProduct({super.key, required this.isEdit, this.data});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController otherCategoryController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  List<File> selectedImages = [];
  List<Map<String, dynamic>> detailsData = [];
  bool isValidate = false, isEdit = false;
  int id = 1;
  VerifyOtpModel? userModel;
  final localStorage = getIt<MySharedPref>();

  List<String> category = [
    'Insectisides',
    'Fertilizers',
    'Machinery',
    'Seeds',
    'Pesticides',
    'Plants',
  ];
  String selectedCategory = 'Insectisides';

  List<String> productType = [
    'ml',
    'kg',
    'gm',
    'ltr',
    'units',
  ];
  String selectedProductType = 'ml';

  // choose multiple image from gallary
  Future _getMultipleImageFromGallery() async {
    try {
      final multiImages =
          await ImagePicker().pickMultiImage(requestFullMetadata: true);
      List<XFile> xfilePick = multiImages;

      setState(
        () {
          if (xfilePick.isNotEmpty) {
            for (var i = 0; i < xfilePick.length; i++) {
              selectedImages.add(File(xfilePick[i].path));
            }
          } else {
            showCustomToast(context, 'Nothing is selected', true);
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    var rawData = localStorage.getUserData();
    if (rawData != null && rawData != "") {
      var userData = jsonDecode(rawData);

      userModel = VerifyOtpModel.fromJson(userData);
    }

    if (widget.data != null) {
      productNameController.text = widget.data!.name!;
      descriptionController.text = widget.data!.description!;
      priceController.text = widget.data!.details!.single.price.toString();
      salePriceController.text =
          widget.data!.details!.single.salePrice.toString();
      quantityController.text =
          widget.data!.details!.single.quantity.toString();
      sizeController.text = widget.data!.details!.single.size.toString();
    }
  }

  // add variant function
  // Future _addVariant() async {
  //   try {
  //     Map<String, dynamic> jsonObject = {
  //       'id': id,
  //       'size': sizeController.text.toString().trim(),
  //       'type': selectedProductType,
  //       'price': priceController.text.toString().trim(),
  //       'sale_price': salePriceController.text.toString().trim(),
  //       'quantity': quantityController.text.toString().trim(),
  //     };
  //     bool found =
  //         detailsData.any((item) => '${item["type"]}' == selectedProductType);

  //     if (found) {
  //       showCustomToast(context, "You cann't add same variant type.", true);
  //     } else {
  //       detailsData.add(jsonObject);
  //       salePriceController.text = "";
  //       quantityController.text = "";
  //       sizeController.text = "";
  //       priceController.text = "";
  //       selectedProductType = 'ml';
  //     }

  //     String jsonString = jsonEncode(detailsData);

  //     setState(() {
  //       id++;
  //     });

  //     print('jsonString==> $jsonString');
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // delete variant function
  // Future _deleteVariant(int id) async {
  //   try {
  //     detailsData.removeWhere((element) => element['id'] == id);
  //     setState(() {});
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // edit variant function
  // Future _editVariant() async {
  //   try {
  //     Map<String, dynamic> newData = {
  //       "id": id,
  //       "size": sizeController.text.toString().trim(),
  //       "type": selectedProductType,
  //       "price": priceController.text.toString().trim(),
  //       "sale_price": salePriceController.text.toString().trim(),
  //       "quantity": quantityController.text.toString().trim()
  //     };

  //     for (int i = 0; i < detailsData.length; i++) {
  //       if (detailsData[i]['id'] == id) {
  //         detailsData[i] = newData;
  //         break;
  //       }
  //     }

  //     salePriceController.text = "";
  //     quantityController.text = "";
  //     sizeController.text = "";
  //     priceController.text = "";
  //     selectedProductType = 'ml';
  //     isEdit = false;

  //     setState(() {});
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  // delete variant function
  Future _deleteImage(File file) async {
    try {
      selectedImages.remove(file);
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    salePriceController.dispose();
    descriptionController.dispose();
    quantityController.dispose();
    sizeController.dispose();
    otherCategoryController.dispose();
    priceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Platform.isAndroid
              ? Icons.arrow_back_rounded
              : Icons.arrow_back_ios_rounded),
        ),
        title: Text(
          widget.isEdit ? 'Edit Product' : 'Add Product',
          style: headLine2.copyWith(fontSize: 20, color: AppColors.white),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductSuccessState) {
            Navigator.of(context).pop();
            showCustomToast(context, state.addProductModel.message!, false);
          }
          if (state is SuccessState) {
            Navigator.of(context).pop();
            showCustomToast(context, state.successResponse.message!, false);
          }
          if (state is ProductErrorState) {
            showCustomToast(context, state.message, true);
          }
        },
        builder: (context, state) {
          if (state is ProductLoadingState) {
            return const Center(
                child: SpinKitIndicator(
              type: SpinKitType.circle,
            ));
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        floatingLabelStyle:
                            const TextStyle(color: AppColors.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                        ),
                      ),
                      value: selectedCategory,
                      items: category.map((String fruit) {
                        return DropdownMenuItem<String>(
                          value: fruit,
                          child: Text(fruit),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          // When the user selects a fruit, update the state to reflect the new value.
                          setState(() {});
                          selectedCategory = newValue;
                        }
                      },
                    ),
                    // SizedBox(
                    //   height: selectedCategory == 'Other' ? 20 : 0,
                    // ),
                    // selectedCategory == 'Other'
                    //     ? CommonInputBox(
                    //         controller: otherCategoryController,
                    //         hintText: 'Other Category',
                    //         keyboardType: TextInputType.name,
                    //         textInputAction: TextInputAction.next,
                    //       )
                    //     : const SizedBox(),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonInputBox(
                      controller: productNameController,
                      hintText: 'Name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonInputBox(
                      controller: descriptionController,
                      hintText: 'Description',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.done,
                      minLines: 3,
                      maxLines: 6,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 + 50,
                          child: CommonInputBox(
                            controller: sizeController,
                            hintText: 'Size',
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            maxLength: 5,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: 100,
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Type',
                              floatingLabelStyle:
                                  const TextStyle(color: AppColors.primary),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.5,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                            ),
                            value: selectedProductType,
                            items: productType.map((String size) {
                              return DropdownMenuItem<String>(
                                value: size,
                                child: Text(size),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                // When the user selects a fruit, update the state to reflect the new value.
                                selectedProductType = newValue;
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          child: CommonInputBox(
                            controller: priceController,
                            hintText: 'Price',
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            maxLength: 5,
                            prefixIcon:
                                const Icon(Icons.currency_rupee_rounded),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 15,
                          child: CommonInputBox(
                            controller: salePriceController,
                            hintText: 'Sale Price',
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.done,
                            maxLength: 5,
                            prefixIcon:
                                const Icon(Icons.currency_rupee_rounded),
                            overrideValidator: true,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              } else if (int.parse(salePriceController.text) >
                                  int.parse(priceController.text)) {
                                return 'Sale price must be smaller than price';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonInputBox(
                      controller: quantityController,
                      hintText: 'Quantity',
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      maxLength: 4,
                      prefixIcon:
                          const Icon(Icons.production_quantity_limits_rounded),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Align(
                    //   alignment: Alignment.centerRight,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       if (_formkey.currentState!.validate()) {
                    //         setState(() {
                    //           isValidate = true;
                    //         });
                    //         isEdit ? _editVariant() : _addVariant();
                    //       } else {
                    //         setState(() {
                    //           isValidate = false;
                    //         });
                    //       }
                    //     },
                    //     child: Text(
                    //       !isEdit ? 'Add Variant' : 'Edit Variant',
                    //       style: headLine2.copyWith(
                    //           decoration: TextDecoration.underline,
                    //           decorationColor: AppColors.primary,
                    //           color: AppColors.primary),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: detailsData.isEmpty ? 0 : 180,
                    //   child: detailsData.isEmpty
                    //       ? const SizedBox()
                    //       : ListView.separated(
                    //           scrollDirection: Axis.horizontal,
                    //           itemCount: detailsData.length,
                    //           itemBuilder: (BuildContext context, int index) {
                    //             return Container(
                    //               width: 180,
                    //               // height: 200,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: BorderRadius.circular(15),
                    //                   border: Border.all(
                    //                       width: 1,
                    //                       color: AppColors.greyTextColor)),
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.start,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0)
                    //                         .copyWith(bottom: 0),
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         RichText(
                    //                           text: TextSpan(
                    //                             text: 'Size: ',
                    //                             style: headLine5.copyWith(
                    //                                 color: AppColors.black),
                    //                             children: <TextSpan>[
                    //                               TextSpan(
                    //                                   text:
                    //                                       '${detailsData[index]['size']}',
                    //                                   style: headLine4.copyWith(
                    //                                       color: AppColors.gary)),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                         RichText(
                    //                           text: TextSpan(
                    //                             text: 'Type: ',
                    //                             style: headLine5.copyWith(
                    //                                 color: AppColors.black),
                    //                             children: <TextSpan>[
                    //                               TextSpan(
                    //                                   text:
                    //                                       '${detailsData[index]['type']}',
                    //                                   style: headLine4.copyWith(
                    //                                       color: AppColors.gary)),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   // const SizedBox(
                    //                   //   height: 8,
                    //                   // ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0)
                    //                         .copyWith(bottom: 0),
                    //                     child: Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         RichText(
                    //                           text: TextSpan(
                    //                             text: 'Price: ',
                    //                             style: headLine5.copyWith(
                    //                                 color: AppColors.black),
                    //                             children: <TextSpan>[
                    //                               TextSpan(
                    //                                   text:
                    //                                       '${detailsData[index]['price']}',
                    //                                   style: headLine4.copyWith(
                    //                                       color: AppColors.gary)),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                   ),
                    //                   // const SizedBox(
                    //                   //   height: 8,
                    //                   // ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0)
                    //                         .copyWith(bottom: 0),
                    //                     child: RichText(
                    //                       text: TextSpan(
                    //                         text: 'Sale Price: ',
                    //                         style: headLine5.copyWith(
                    //                             color: AppColors.black),
                    //                         children: <TextSpan>[
                    //                           TextSpan(
                    //                               text:
                    //                                   '${detailsData[index]['sale_price']}',
                    //                               style: headLine4.copyWith(
                    //                                   color: AppColors.gary)),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   // const SizedBox(
                    //                   //   height: 8,
                    //                   // ),
                    //                   Padding(
                    //                     padding: const EdgeInsets.all(8.0)
                    //                         .copyWith(bottom: 0),
                    //                     child: RichText(
                    //                       text: TextSpan(
                    //                         text: 'Quantity: ',
                    //                         style: headLine5.copyWith(
                    //                             color: AppColors.black),
                    //                         children: <TextSpan>[
                    //                           TextSpan(
                    //                               text:
                    //                                   '${detailsData[index]['quantity']}',
                    //                               style: headLine4.copyWith(
                    //                                   color: AppColors.gary)),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                   const SizedBox(
                    //                     height: 8,
                    //                   ),
                    //                   const Divider(
                    //                     height: 1,
                    //                     color: AppColors.greyTextColor,
                    //                   ),
                    //                   Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceBetween,
                    //                     children: [
                    //                       IconButton(
                    //                           onPressed: () {
                    //                             isEdit = true;
                    //                             id = detailsData[index]['id'];
                    //                             salePriceController.text =
                    //                                 detailsData[index]
                    //                                     ['sale_price'];
                    //                             quantityController.text =
                    //                                 detailsData[index]['quantity'];
                    //                             sizeController.text =
                    //                                 detailsData[index]['size'];
                    //                             priceController.text =
                    //                                 detailsData[index]['price'];
                    //                             selectedProductType =
                    //                                 detailsData[index]['type'];

                    //                             setState(() {});
                    //                           },
                    //                           icon: const Icon(Icons.edit_rounded)),
                    //                       Container(
                    //                         width: 1,
                    //                         height: 53,
                    //                         color: AppColors.greyTextColor,
                    //                       ),
                    //                       IconButton(
                    //                           onPressed: () {
                    //                             _deleteVariant(
                    //                                 detailsData[index]['id']);
                    //                           },
                    //                           icon: const Icon(
                    //                             Icons.delete_rounded,
                    //                             color: Colors.red,
                    //                           )),
                    //                     ],
                    //                   )
                    //                 ],
                    //               ),
                    //             );
                    //           },
                    //           separatorBuilder: (BuildContext context, int index) {
                    //             return const SizedBox(
                    //               width: 15,
                    //             );
                    //           },
                    //         ),
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _getMultipleImageFromGallery();
                      },
                      child: Center(
                        child: Image.asset(
                          Images.image,
                          width: 200,
                          height: 100,
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Click to button for ',
                        style: headLine2.copyWith(fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _getMultipleImageFromGallery();
                                },
                              text: 'uploading ',
                              style:
                                  headLine2.copyWith(color: AppColors.primary)),
                          TextSpan(
                              text: 'product images',
                              style: headLine2.copyWith(fontSize: 15)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: selectedImages.isEmpty ? 0 : 150,
                      child: selectedImages.isEmpty
                          ? const SizedBox()
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: selectedImages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    Center(
                                        child: Image.file(
                                      selectedImages[index],
                                      width: 140,
                                      height: 140,
                                    )),
                                    Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: IconButton(
                                          color: Colors.red,
                                          onPressed: () {
                                            _deleteImage(selectedImages[index]);
                                          },
                                          icon: const Icon(
                                            Icons.close_rounded,
                                            size: 30,
                                          )),
                                    )
                                  ],
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CommonButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              if (selectedImages.isEmpty) {
                showCustomToast(context, 'Please upload images', true);
              } else {
                FormData params = FormData.fromMap({
                  "Category": selectedCategory,
                  "Name": productNameController.text.toString().trim(),
                  "Description": descriptionController.text.toString().trim(),
                  "Type": selectedProductType,
                  "Size": sizeController.text.toString().trim(),
                  "Price": priceController.text.toString().trim(),
                  "Sale_Price": salePriceController.text.toString().trim(),
                  "Quantity": quantityController.text.toString().trim(),
                  "SellerId": userModel!.response!.roleId ?? "",
                });

                FormData params1 = FormData.fromMap({
                  "Category": selectedCategory,
                  "Name": productNameController.text.toString().trim(),
                  "Description": descriptionController.text.toString().trim(),
                  "Type": selectedProductType,
                  "Size": sizeController.text.toString().trim(),
                  "Price": priceController.text.toString().trim(),
                  "Sale_Price": salePriceController.text.toString().trim(),
                  "Quantity": quantityController.text.toString().trim(),
                  'Id': widget.isEdit
                      ? widget.data!.details!.single.id!.toString()
                      : 0,
                  "SellerId": userModel!.response!.roleId ?? "",
                });
                // Add images to FormData
                for (int i = 0; i < selectedImages.length; i++) {
                  String fileName = selectedImages[i].path.split('/').last;
                  params.files.add(
                    MapEntry(
                      "Images",
                      await MultipartFile.fromFile(selectedImages[i].path,
                          filename: fileName),
                    ),
                  );
                }

                for (int i = 0; i < selectedImages.length; i++) {
                  String fileName = selectedImages[i].path.split('/').last;
                  params1.files.add(MapEntry(
                      "Images",
                      await MultipartFile.fromFile(selectedImages[i].path,
                          filename: fileName)));
                }
                widget.isEdit
                    ? context
                        .read<ProductCubit>()
                        .editProduct(
                        params1,
                        widget.data!.productId!,
                        widget.data!.details!.single.id!)
                    : context.read<ProductCubit>().addProduct(params);
              }
            }
          },
          buttonText: 'Save',
          buttonColor: AppColors.primary,
          buttonTextColor: AppColors.white,
          height: 50,
        ),
      ),
    );
  }
}
