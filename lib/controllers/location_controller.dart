import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:instagram/utils/custom_toast_util.dart';

class LocationController extends GetxController {
  final RxBool isLoadingLocation = false.obs;
  final RxString selectedLocation = ''.obs;

  Future<void> getCurrentLocation(BuildContext context) async {
    try {
      isLoadingLocation.value = true;

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        CustomToastUtil.showError(
          context,
          message: 'Please enable location services',
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        CustomToastUtil.showError(
          context,
          message: 'Location permission is permanently denied.',
        );

        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      selectedLocation.value =
          "${place.locality ?? ''}, ${place.country ?? ''}";
    } catch (e) {
      CustomToastUtil.showError(context, message: e.toString());
    } finally {
      isLoadingLocation.value = false;
    }
  }
}
