import 'dart:async';

import 'package:driver_app/app/base/app_constants.dart';
import 'package:driver_app/app/base/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final Completer<GoogleMapController> googleMapController = Completer<GoogleMapController>();
  LatLng sourceLocation = const LatLng (37.33500926, -122.03272188);
  LatLng destination = const LatLng (37.33429383, -122.06600055);

  RxDouble currentLatitude = 0.0.obs;
  RxDouble currentLongitude = 0.0.obs;

  Rx<BitmapDescriptor> driverIcon = BitmapDescriptor.defaultMarker.obs;

  RxList<LatLng> polylineCoordinates =<LatLng>[].obs;

  void setCustomMapPin() async{
    driverIcon.value = await BitmapDescriptor.fromAssetImage(
    const ImageConfiguration(devicePixelRatio: 2.5, size: Size(20, 20)),
    AppStrings.driverIcon,
    );
  }

  void getPolyPoints() async{
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    AppConstants.googleApiKey,
    PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
    PointLatLng(destination. latitude, destination. longitude),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
    LatLng(point. latitude, point. longitude),
        );
      }
    }
  }

  void getCurrentLocation()async{
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData driverLocation = await location.getLocation();

    currentLatitude.value = driverLocation.latitude!;
    currentLongitude.value = driverLocation.longitude!;
    final GoogleMapController controller = await googleMapController.future;
    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      currentLatitude.value = currentLocation.latitude!;
      currentLongitude.value = currentLocation.longitude!;
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(currentLocation.latitude!, currentLocation.longitude!), zoom: 13.5)));

    });

  }

 @override
  void onInit() {
    // TODO: implement onInit
   getPolyPoints();
   setCustomMapPin();
   getCurrentLocation();
    super.onInit();
  }

}
