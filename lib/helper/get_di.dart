import 'package:barikoi/api/api_client.dart';
import 'package:barikoi/features/map/controllers/map_controller.dart';
import 'package:barikoi/features/map/domain/repository/map_repo.dart';
import 'package:barikoi/utils/appconstants.dart';
import 'package:get/get.dart';

void init(){

  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.appBaseUrl));
  Get.lazyPut(() => MapRepo(apiClient: Get.find()));
  Get.lazyPut(() => MapController(mapRepo: Get.find()));

}