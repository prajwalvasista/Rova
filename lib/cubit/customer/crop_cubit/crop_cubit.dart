import 'package:al_rova/cubit/customer/crop_cubit/crop_state.dart';
import 'package:al_rova/models/customer/crop/crop_disease_model.dart';
import 'package:al_rova/repositories/customer/crop_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CropCubit extends Cubit<CropState> {
  final CropRepository cropRepository;
  CropCubit({required this.cropRepository}) : super(CropInitalState());

  Future<dynamic> fetchCropDiseaseName(String cityName) async {
    emit(CropLoadingState());

    final result = await cropRepository.cropDiseaseName(cityName);
    result.fold(
      (failure) {
        emit(CropErrorState(failure.message));
        // return [];
      },
      (r) {
        if (r is CropDiseaseModel) {
          emit(CropSuccessState(r));
        } else {
          emit(ObjectDetectionState(r));
        }
        //  return r;
      },
    );
  }

  Future<dynamic> fetchCropDetail(String diseaseModelName) async {
    emit(CropLoadingState());

    final result = await cropRepository.getCropInfo(diseaseModelName);
    result.fold(
      (failure) {
        emit(CropErrorState(failure.message));
        // return [];
      },
      (r) {
        emit(CropDetailState(r));
      },
    );
  }
}
