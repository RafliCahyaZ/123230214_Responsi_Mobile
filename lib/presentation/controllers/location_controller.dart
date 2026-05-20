import 'package:get/get.dart';

import '../../data/services/location_service.dart';

class LocationController extends GetxController {
  LocationController(this._locationService);

  final LocationService _locationService;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<UserLocation> location = Rxn<UserLocation>();

  Future<void> getLocation() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      location.value = await _locationService.getCurrentLocation();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }
}
