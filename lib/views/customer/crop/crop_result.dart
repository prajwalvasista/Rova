import 'dart:io';
import 'package:al_rova/common/widget/spinkit_indicator.dart';
import 'package:al_rova/cubit/customer/crop_cubit/crop_cubit.dart';
import 'package:al_rova/cubit/customer/crop_cubit/crop_state.dart';
import 'package:al_rova/models/customer/crop/crop_detail_model.dart';
import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:al_rova/utils/widgets/common_button.dart';
import 'package:al_rova/utils/widgets/toast/show_common_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CropResult extends StatefulWidget {
  String modelName;
  String image;
  CropResult({super.key, required this.modelName, required this.image});

  @override
  State<CropResult> createState() => _CropResultState();
}

class _CropResultState extends State<CropResult> {
  ValueNotifier<bool> isSpeaking = ValueNotifier(false);

  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    context.read<CropCubit>().fetchCropDetail(widget.modelName);
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: null,
        body: BlocConsumer<CropCubit, CropState>(
          listener: (context, state) {
            if (state is CropErrorState) {
              showCustomToast(context, state.message, true);
            }
          },
          builder: (context, state) {
            return (state is CropDetailState &&
                    (state.cropDetailModel.data == [] ||
                        state.cropDetailModel.data == null))
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(Images.emptyState),
                      const Text(
                        "Crop details not found",
                        style: TextStyle(color: AppColors.black, fontSize: 16),
                      ),
                      CommonButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          buttonText: 'Go Back',
                          buttonColor: AppColors.primary,
                          buttonTextColor: AppColors.white)
                    ],
                  ))
                : (state is CropErrorState)
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(Images.emptyState),
                          Text(
                            state.message,
                            style: const TextStyle(
                                color: AppColors.black, fontSize: 16),
                          ),
                          CommonButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              buttonText: 'Go Back',
                              buttonColor: AppColors.primary,
                              buttonTextColor: AppColors.white)
                        ],
                      ))
                    : (state is CropLoadingState)
                        ? const Center(
                            child: SpinKitIndicator(
                            type: SpinKitType.circle,
                          ))
                        : (state is CropDetailState)
                            ? SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topLeft,
                                      children: [
                                        Image.file(
                                          File(widget.image),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 500,
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.high,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 48.0, left: 12),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      width: MediaQuery.of(context).size.width,
                                      transform: Matrix4.translationValues(
                                          0.0, -150.0, 0.0),
                                      //   height: MediaQuery.of(context).size.height * 0.6,
                                      decoration: const ShapeDecoration(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(26),
                                            topRight: Radius.circular(26),
                                          ),
                                        ),
                                        shadows: [
                                          BoxShadow(
                                            color: Color(0x26000000),
                                            blurRadius: 16,
                                            offset: Offset(0, -6),
                                            spreadRadius: 0,
                                          )
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Hurray, we identified the Disease',
                                                style: TextStyle(
                                                  color: Color(0xFF6EA646),
                                                  fontSize: 16,
                                                  fontFamily: 'DM Sans',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: AppColors.lightGary,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ValueListenableBuilder(
                                                    valueListenable: isSpeaking,
                                                    builder: (BuildContext
                                                            buildContext,
                                                        bool isSpeaking,
                                                        child) {
                                                      return IconButton(
                                                          onPressed: () {
                                                            if (isSpeaking) {
                                                              _pause();
                                                            } else {
                                                              _speak(cropDiseaseToString(
                                                                  state
                                                                      .cropDetailModel
                                                                      .data!));
                                                            }
                                                          },
                                                          highlightColor:
                                                              AppColors.white,
                                                          color:
                                                              AppColors.black,
                                                          iconSize: 30,
                                                          icon: Icon(isSpeaking
                                                              ? Icons
                                                                  .pause_circle
                                                              : Icons
                                                                  .play_circle_rounded));
                                                    }), //

                                                Expanded(
                                                  child: Text(
                                                    'Use the play button for convenient audio engagement with the content.',
                                                    style: headLine6.copyWith(
                                                        fontSize: 13.5),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            state.cropDetailModel.data
                                                    ?.cropDiseaseName ??
                                                "",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 30,
                                              fontFamily: 'DM Sans',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            'Symptoms',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 22,
                                              fontFamily: 'DM Sans',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          ListView.separated(
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              var item = state.cropDetailModel
                                                      .data?.symptoms ??
                                                  [];
                                              return Text(
                                                item[index],
                                                style: const TextStyle(
                                                  color: Color(0xFF011928),
                                                  fontSize: 17,
                                                  fontFamily: 'DM Sans',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              );
                                            },
                                            itemCount: state.cropDetailModel
                                                    .data?.symptoms?.length ??
                                                0,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              height: 10,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            'Solutions',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xFF333333),
                                              fontSize: 22,
                                              fontFamily: 'DM Sans',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          ListView.separated(
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              var item = state.cropDetailModel
                                                      .data?.solutions ??
                                                  [];

                                              return Text(
                                                item[index],
                                                style: const TextStyle(
                                                  color: Color(0xFF011928),
                                                  fontSize: 17,
                                                  fontFamily: 'DM Sans',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              );
                                            },
                                            itemCount: state.cropDetailModel
                                                    .data?.solutions?.length ??
                                                0,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                              height: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox();
          },
        ),
        bottomNavigationBar: BlocBuilder<CropCubit, CropState>(
          builder: (context, state) {
            if (state is CropDetailState) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CommonButton(
                  onPressed: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const ShopStoreListScreen()));
                  },
                  buttonText: 'Nearby Store',
                  buttonColor: AppColors.primary,
                  buttonTextColor: AppColors.white,
                  height: 48,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ));
  }

// speak text to speech
  Future _speak(String text) async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setPitch(1.0);
    await flutterTts.setVolume(1.0);
    await flutterTts.speak(text);

    isSpeaking.value = true;
    isSpeaking.notifyListeners();

    flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
      isSpeaking.notifyListeners();
    });
  }

  Future _pause() async {
    await flutterTts.stop();

    isSpeaking.value = false;
    isSpeaking.notifyListeners();
  }

  String cropDiseaseToString(Data data) {
    return """
    Crop Disease Name: ${data.cropDiseaseName}
    Symptoms: ${data.symptoms!.join("\n")}
    Solutions: ${data.solutions!.join("\n")}
    """;
  }
}
