import 'package:al_rova/core/errors/failures.dart';
import 'package:al_rova/core/network/api_endpoints.dart';
import 'package:al_rova/core/network/api_service.dart';
import 'package:al_rova/core/network/error_handler.dart';
import 'package:al_rova/core/network/network_info.dart';
import 'package:al_rova/models/customer/store/shop_store_model.dart';
import 'package:dartz/dartz.dart';

class ShopStoreRepository {
  final ApiService apiService;
  final NetworkInfo networkInfo;

  ShopStoreRepository({required this.apiService, required this.networkInfo});

  Future<Either<Failure, List<StoreShopModel>>> getShopStore(
      String cityName) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await apiService.get(
            endPoint: "${APIEndPoints.shopStore}$cityName");
        List<StoreShopModel> storeShopModelList = response.data["data"]
            .map<StoreShopModel>((item) => StoreShopModel.fromJson(item))
            .toList();

        return Right(storeShopModelList);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
